#
# Cookbook Name:: wt_netacuity
# Recipe:: default
#
# Copyright 2012, Webtrends Inc.
#
# All rights reserved - Do Not Redistribute
#

source_tarball   = node['wt_netacuity']['download_url'][/\/([^\/\?]+)(\?.*)?$/, 1]
source_localpath = File.join(Chef::Config[:file_cache_path], source_tarball)

# create service user
group 'netacuity'
user  'netacuity' do
  comment 'NetAcuity User'
  gid 'netacuity'
  home '/home/netacuity'
  shell '/bin/bash'
  supports :manage_home => true
end

# create the install directory
directory node['wt_netacuity']['install_dir'] do
  owner 'netacuity'
  group 'netacuity'
  mode 00755
  recursive true
  action :create
end

# pull the install .tgz file down from the repo
remote_file source_localpath do
  source node['wt_netacuity']['download_url']
  mode 00644
  only_if do ! File.exists?("#{node['wt_netacuity']['install_dir']}/server/netacuity_server") end
end

# uncompress the install .tgz
execute 'tar' do
  user  'netacuity'
  group 'netacuity'
  cwd node['wt_netacuity']['install_dir']
  command "tar zxf #{source_localpath}"
  action :nothing
  subscribes :run, resources(:remote_file => source_localpath), :immediately
end

# delete the netacuity tarball
execute 'cleanup' do
  command "rm -f #{source_localpath}"
  action :nothing
  only_if do File.exists?(source_localpath) end
  subscribes :run, resources(:execute => 'tar')
end

# chown install_dir
execute 'chown' do
  user 'root'
  command "chown -R netacuity:netacuity #{node['wt_netacuity']['install_dir']}"
  action :nothing
  subscribes :run, resources(:execute => 'tar'), :immediately
end

# create the init script from a template
template 'netacuity-init' do
  path '/etc/init.d/netacuity'
  source 'NetAcuity.erb'
  owner 'root'
  group 'root'
  mode 00755
  notifies :run, resources(:execute => 'chown'), :immediately
end

# enable the service and start it
service 'netacuity' do
  enabled true
  running true
  pattern 'netacuity_server'
  supports :status => false, :restart => true, :reload => false
  action [ :enable, :start ]
end

# create the config file from a template
template 'netacuity-config' do
  path "#{node['wt_netacuity']['install_dir']}/server/netacuity.cfg"
  owner 'netacuity'
  group 'netacuity'
  source 'netacuity.cfg.erb'
  notifies :run,     resources(:execute => 'chown'), :immediately
  notifies :restart, resources(:service => 'netacuity')
end

# grab the admin password from the data bag
auth_data = data_bag_item('authorization', node.chef_environment)
admin_passenc = auth_data['wt_netacuity']['admin_password'].crypt('wt')

# create the password file from a template
template 'netacuity-passwd' do
  path "#{node['wt_netacuity']['install_dir']}/server/netacuity.passwd"
  owner 'netacuity'
  group 'netacuity'
  source 'netacuity.passwd.erb'
  variables(
    :admin_password => admin_passenc
  )
end

if node.attribute?('nagios')
  #Create a nagios nrpe check to directly query netacuity for data using webtrends.com's IP
	nagios_nrpecheck 'wt_netacuity_check' do
		command "#{node['nagios']['plugin_dir']}/check_netacuity.rb"
		parameters 'localhost 216.223.23.5'
		action :add
	end

  #Copy in the nrpe netacuity check plugin config file.
	cookbook_file "#{node['nagios']['plugin_dir']}/check_netacuity.rb" do
		source 'check_netacuity.rb'
		mode 00755
	end

	#Create a nagios nrpe command for the restart event handler
	nagios_nrpecheck 'restart_netacuity' do
		command "#{node['nagios']['plugin_dir']}/restart_netacuity"
		action :add
	end

	#Copy in the event handler plugin
	cookbook_file "#{node['nagios']['plugin_dir']}/restart_netacuity" do
		source 'restart_netacuity'
		mode 00755
	end

end
