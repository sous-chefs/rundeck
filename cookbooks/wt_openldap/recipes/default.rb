#
# Cookbook Name:: wt_openldap
# Recipe:: default
# Author:: David Dvorak (<david.dvorak@webtrends.com>)
#
# Copyright 2013, Webtrends Inc.
#
# All rights reserved - Do Not Redistribute
#

# openldap client tools
package 'ldap-utils' do
	version node['wt_openldap']['version']
	action :install
end

# get admin password
begin
	$admin_password = data_bag_item('authorization', node.chef_environment)['wt_openldap']['admin_password']
rescue
	raise 'no admin password defined'
end

# openldap server
package 'slapd' do
	version node['wt_openldap']['version']
	response_file 'slapd.seed.erb'
	action :install
end

# delete seed file
seed_file = File.join(Chef::Config[:file_cache_path], 'preseed', cookbook_name, "slapd-#{node['wt_openldap']['version']}.seed")
file seed_file do
	backup false
	action :delete
end

# extra module
cookbook_file '/usr/lib/ldap/slapd-sha2.so' do
	mode 00755
	action :create
end

cookbook_file '/etc/default/slapd' do
	mode 00644
	action :create
end

# certificate common_name
common_name = node['wt_openldap']['common_name'] || node['fqdn']

# ssl files
csr = "/etc/ldap/#{common_name}.csr"
key = "/etc/ldap/#{common_name}.key"
crt = "/etc/ldap/#{common_name}.crt"

# generate a csr and key
execute 'generate_csr' do
	command "openssl req -out #{csr} -new -newkey rsa:2048 -nodes -keyout #{key} -subj '/C=US/ST=Oregon/L=Portland/O=Webtrends Inc./OU=Engineering/CN=#{common_name}'"
	creates key
	action :run
end

unless File.exists? crt
	log "\n##\n## Signed certificate is required here: #{crt}\n##" do
		level :error
	end
end

# upstream CA's
cookbook_file '/etc/ldap/wt.ca.chain.crt' do
	mode 00644
	action :create
end

wt_openldap_config 'olcTLSCACertificateFile' do
	value '/etc/ldap/wt.ca.chain.crt'
	only_if { File.exists?('/etc/ldap/wt.ca.chain.crt') }
end

wt_openldap_config 'olcTLSCertificateFile' do
	value crt
	only_if { File.exists?(crt) }
end

wt_openldap_config 'olcTLSCertificateKeyFile' do
	value key
	only_if { File.exists?(crt) }
end

wt_openldap_config 'olcLogLevel' do
	value 'none'
end

wt_openldap_config 'olcModuleLoad' do
	dn 'cn=module{0},cn=config'
	value 'slapd-sha2'
end

wt_openldap_config 'olcPasswordHash' do
	dn 'olcDatabase={-1}frontend,cn=config'
	value '{sha512}'
end

service 'slapd' do
	supports :start => true, :stop => true, :restart => true, :status => true
	action [:enable, :start]
end

# restore a backup file (intended for lab environments)
unless ENV['RESTORE_SOURCE'].nil?

	# get default password
	default_password = data_bag_item('authorization', node.chef_environment)['wt_openldap']['default_password']

	wt_openldap_database 'restore backup' do
		source ENV['RESTORE_SOURCE']
		default_password default_password
		action :restore
	end
end

# set backup cron job

# backup script
script_path = File.join(node['wt_common']['install_dir_linux'], 'bin')
script      = File.join(script_path, 'openldap_backup.sh')

package 'nfs-common'

directory node['wt_openldap']['server_backup']['mount_path'] do
	action :create
end

mount node['wt_openldap']['server_backup']['mount_path'] do
	device node['wt_openldap']['server_backup']['backup_nfs_mount']
	fstype 'nfs'
	options 'rw'
	action [:mount, :enable]
end

directory "#{node['wt_openldap']['server_backup']['mount_path']}/ldap/#{node['fqdn']}" do
	recursive true
	action :create
end

directory script_path do
	recursive true
	action :create
end

template script do
	source 'openldap_backup.sh.erb'
	mode 00755
	owner 'root'
	group 'root'
end

cron 'openldap_backup.sh' do
	hour '0'
	minute '1'
	command script
	action :create
end

