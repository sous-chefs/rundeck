#
# Cookbook Name:: wt_openldap
# Provider:: database
#
# Copyright 2013, Webtrends Inc.
#
# All rights reserved - Do Not Redistribute
#

action :restore do

	source           = new_resource.source
	default_password = new_resource.default_password

	Chef::Log.info("Restoring from backup: #{source}")

	# check if this is local or remote backup file
	if (source =~ /^https?:\/\//)
		restore_file = get_remote_source(source)
	else
		restore_file = get_local_source(source)
	end
	raise "not found: #{source}" if restore_file.nil?

	# set our lab password in restore file
	ruby_block 'set default_password' do
		block do
			restore_text = ::File.read(restore_file).gsub(/^(userPassword:: ).*$/) do
				$1 + %x[ /usr/sbin/slappasswd -h {SSHA} -s '#{default_password}' | base64 ].chomp
			end
			::File.open(restore_file, 'w') { |f| f.puts(restore_text) }
		end
	end

	# create a backup of current server
	ruby_block 'make backup' do
		block do
			backup_file = ::File.join(Chef::Config[:file_cache_path], "ldap-backup-#{node['fqdn']}-#{Time.now.strftime("%Y-%m-%d-%H%M%S")}.ldif")
			output = %x[/usr/sbin/slapcat -o ldif-wrap=no -l "#{backup_file}"]
			raise output if $?.exitstatus != 0
		end
	end

	# stop service
	service 'slapd' do
		action :stop
	end

	# delete current ldap files
	ruby_block 'delete ldap files' do
		block do
			::Dir.glob('/var/lib/ldap/*').each { |f| ::File.delete(f) }
		end
	end

	# restore backup
	execute "slapadd #{restore_file}" do
		command "/usr/sbin/slapadd -v -l \"#{restore_file}\""
	end

	# chown new files
	execute 'chown /var/lib/ldap' do
		command 'chown -R openldap:openldap /var/lib/ldap'
	end

	# start service
	service 'slapd' do
		action :start
	end
end

private

#
# gets remote file and returns path to local copy
#
def get_remote_source source

	local_ldif = ::File.join(Chef::Config[:file_cache_path], source[/\/([^\/\?]+)(\?.*)?$/, 1])

	remote_file local_ldif do
		source source
	end

	return local_ldif
end

#
# returns path to local file
#
def get_local_source source
	::File.realpath(source) if ::File.exists?(source)
end

