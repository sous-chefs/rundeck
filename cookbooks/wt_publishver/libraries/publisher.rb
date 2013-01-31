#
# Cookbook Name:: wt_publishver
# Library:: publisher
# Author:: David Dvorak (<david.dvorak@webtrends.com>)
#
# Copyright 2013, Webtrends Inc.
#
# All rights reserved - Do Not Redistribute
#

module WtPublishver

	class PublisherItem 
		attr_accessor :id, :hostname, :pod, :role, :version, :branch, :build, :status, :os
		def initialize item
			@id = item.id
			@hostname = item.title
			@pod = item.pod
			@role = item.role
			@version = item.wtver
			@branch = item.branch
			@build = item.build
			@status = item.wtstatus
			@os =  item.os
		end

		def formatted
			msg  = sprintf("%-7s : %s\n", 'ID',      @id)
			msg << sprintf("%-7s : %s\n", 'Title',   @hostname)
			msg << sprintf("%-7s : %s\n", 'Pod',     @pod)
			msg << sprintf("%-7s : %s\n", 'Role',    @role)
			msg << sprintf("%-7s : %s\n", 'Version', @version)
			msg << sprintf("%-7s : %s\n", 'Branch',  @branch)
			msg << sprintf("%-7s : %s\n", 'Build',   @build)
			msg << sprintf("%-7s : %s\n", 'OS',      @os)
			msg << sprintf("%-7s : %s\n", 'Status',  @status)
			msg
		end
	end

	class Publisher

		# class attributes
		attr_reader :download_url, :download_server

		# teamcity attributes
		attr_reader :project_name, :buildtype_id, :buildtype_name, :build_id, :build_number, :xmldoc

		# sharepoint attributes for queries
		attr_accessor :hostname, :pod, :role, :selectver

		# old and new publisher items
		attr_accessor :oitem, :nitem

		# constants
		SP_SITEURL  = 'http://compass2.webtrends.corp/private/eng/systems'
		SP_USERNAME = 'wtinstaller@englab.webtrends.corp'
		SP_PASSWORD = 'Bijoux1'
		SP_LISTNAME = 'POD Details'

		# instance objects
		@@tc     = nil
		@@xmldoc = nil
		@@listws = nil
	
		def initialize download_url
			@download_url    = download_url
			@download_server = download_url[/^https?:\/\/([^\/]+)\//, 1]

			# teamcity
			@@tc           = Teamcity.new(@download_server, 80)
			@buildtype_id = @download_url[/\b(bt\d+)\b/, 1]
			@build_id     = get_build_id
			@@xmldoc = get_build_xmldoc(@build_id)
			unless @@xmldoc.nil?
				@buildtype_name  = get_buildtype_name(@@xmldoc.root)
				@project_name    = get_project_name(@@xmldoc.root)
				@build_number    = get_build_number(@@xmldoc)
			end

			# sharepoint
			scli = Viewpoint::SPWSClient.new(SP_SITEURL, SP_USERNAME, SP_PASSWORD)
		    @@listws = scli.lists_ws
		end

		def is_tc?
			@@xmldoc.nil? ? false : true
		end

		def sp_query
			begin
				@@listws.get_pod_items(SP_LISTNAME) do |b|
					 b.Query {
						b.Where {
							b.And {
								b.And {
									b.Eq {
										b.FieldRef(:Name => 'Title')
										b.Value(@hostname, :Type => 'Text')
									}
									b.Eq {
										b.FieldRef(:Name => 'POD')
										b.Value(@pod, :Type => 'Text')
									}
								}
								if @selectver.nil?
									b.Eq {
										b.FieldRef(:Name => 'Role')
										b.Value(@role, :Type => 'Text')
									}
								else
									b.And {
										b.Eq {
											b.FieldRef(:Name => 'Role')
											b.Value(@role, :Type => 'Text')
										}
										b.Eq {
											b.FieldRef(:Name => '_Version')
											b.Value(@selectver, :Type => 'Text')
										}
									}
								end
							}
						}
					}
				end
			rescue
				[]
			end
		end

		def sp_update
			begin
				@@listws.update_list_items(SP_LISTNAME) do |b|
					b.Method(:ID => 1, :Cmd => 'Update') {
						b.Field(@oitem.id,  :Name => 'ID')
						b.Field(@nitem.version, :Name => '_Version') unless @nitem.version.nil? or @oitem.version == @nitem.version
						b.Field(@nitem.branch,  :Name => 'Branch')   unless @nitem.branch.nil?  or @oitem.branch  == @nitem.branch
						b.Field(@nitem.build,   :Name => 'Build')    unless @nitem.build.nil?   or @oitem.build   == @nitem.build
						b.Field(@nitem.os,      :Name => 'OS')       unless @nitem.os.nil?      or @oitem.os      == @nitem.os
						b.Field(@nitem.status,  :Name => '_Status')  unless @nitem.status.nil?  or @oitem.status  == @nitem.status
					}
				end
			rescue
				Chef::Log.warn 'Error while updating Pod Details list.'
			end
		end

		def changed?
			return true unless @oitem.version.to_s == @nitem.version.to_s
			return true unless @oitem.branch.to_s  == @nitem.branch.to_s
			return true unless @oitem.build.to_s   == @nitem.build.to_s
			return true unless @oitem.os.to_s      == @nitem.os.to_s
			return true unless @oitem.status.to_s  == @nitem.status.to_s
			return false
		end

		def jar_build jarfile

			# working directory
			wdir = File.join(Chef::Config[:file_cache_path], 'wt_publishver')

			# extract manifest file
			system "cd #{wdir} && jar xf \"#{jarfile}\" META-INF/MANIFEST.MF"
			manifest_file = File.join(wdir, 'META-INF/MANIFEST.MF')

			# read manifest
			if File.exists? manifest_file
				mani = Manifest.read(File.open(manifest_file).read)
			else
				return
			end

			# determine version + build
			jar_build_number = Array.new
			jar_build_number << mani.first['Implementation-Version'] unless mani.first['Implementation-Version'].nil?
			jar_build_number << mani.first['Implementation-Build']   unless mani.first['Implementation-Build'].nil?
			return jar_build_number.join('.')
		end

		private
	
		def get_build_id
			case @download_url
				when /\b(\d+):id\b/i
					$1
				when /(\.lastSuccessful)\b/i
					@@tc.builds({ :locator => "buildType:#{@buildtype_id},status:SUCCESS" }).first.id
			end
		end
	
		def get_build_xmldoc id
			begin
				REXML::Document.new @@tc.authentication.get("/app/rest/builds/id:#{id}")
			rescue OpenURI::HTTPError
				return
			end
		end
	
		def get_buildtype_name doc
			doc.elements['buildType'].attributes['name']
		end
	
		def get_project_name doc
			doc.elements['buildType'].attributes['projectName']
		end
	
		def get_build_number doc
			doc.elements["build[@id='#{@build_id}']"].attributes['number']
		end
	end
end
