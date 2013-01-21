# #
# # Cookbook Name:: wt_publishver
# # Recipe:: linux
# #
# # Copyright 2012, Webtrends Inc.
# #
# # All rights reserved - Do Not Redistribute
# #
# 
# # older platforms are not supported
# return if node['platform_family'] == 'debian' && node['platform_version'].to_i < 12
# 
# # working directories
# wdir = File.join(Chef::Config[:file_cache_path], 'wt_publishver')
# gdir = File.join(wdir, 'gems')
# idir = File.join(wdir, 'include')
# ldir = File.join(wdir, 'lib')
# 
# ENV['GEM_HOME'] = gdir
# 
# remote_directory wdir do
# 	source 'prereqs'
# 	overwrite true
# 	action :nothing
# end.run_action :create
# 
# gem_package 'nokogiri' do
# 	gem_binary 'gem'
# 	source File.join(wdir, 'nokogiri-1.5.6.gem')
# 	options "--install-dir #{gdir} -- --with-xml2-lib=#{ldir} --with-xml2-include=#{idir}/libxml2 --with-xslt-lib=#{ldir} --with-xslt-include=#{idir} --with-dldflags='-Wl,-rpath,#{ldir}'"
# 	action :nothing
# end.run_action :install
# 
# gem_list = ['little-plugger-1.1.3', 'multi_json-1.5.0', 'logging-1.6.1', 'httpclient-2.2.4', 'rubyntlm-0.1.2', 'viewpoint-spws-0.5.0.wt']
# gem_list.each do |gem|
# 	gem_package gem[/^(.*)-[\d\.wt]+?/, 1] do
# 		gem_binary 'gem'
# 		source File.join(wdir, "#{gem}.gem")
# 		options "--install-dir #{gdir} --ignore-dependencies"
# 		action :nothing
# 	end.run_action :install
# end
# 
# Gem.clear_paths
# 
# require 'viewpoint/spws'
# 
# def get_teamcity_branch (download_url)
# 
# 	download_server = download_url[/^https?:\/\/([^\/]+)\//, 1]
# 
# 	if download_url =~ /\b(bt\d+)\b/
# 		buildtype_id = $1
# 	else
# 		return false
# 	end
# 
# 	tc = Teamcity.new(download_server, 80)
# 
# 	tc.build_types.each do |bt|
# 		return "#{bt.project_name}_#{bt.name}".gsub(/ /, '_') if bt.id == buildtype_id
# 	end
# 
# end
# 
# def publish_version (params)
# 
# 	role         = params[:role]
# 	download_url = params[:download_url]
# 	key_file     = params[:key_file]
# 	status       = params[:status] || 'Up'
# 
# 	download_server = download_url[/^https?:\/\/([^\/]+)\//, 1]
# 
# 	branch = get_teamcity_branch(download_url) || download_server
# 
# 	log "branch => #{branch}"
# 
# end
# 
# 
# node['roles'].each do |r|
# 	case r
# 		when 'wt_streaming_api_server'
# 			log "publishing #{r}"
# 			publish_version(
# 				:role         => 'Streaming API',
# 				:download_url => node['wt_streamingapi']['download_url']
# 			)
# 		else
# 			log "no publishing data for role => #{r}"
# 	end
# end
# 
