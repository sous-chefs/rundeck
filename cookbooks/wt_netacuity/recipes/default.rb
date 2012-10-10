#
# Cookbook Name:: wt_netacuity
# Recipe:: default
#
# Copyright 2012, Webtrends
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# create the install directory
directory node['wt_netacuity']['install_dir'] do
  owner "root"
  group "root"
  mode 00755
  recursive true
  action :create
end

# pull the install .tgz file down from the repo
remote_file "#{Chef::Config[:file_cache_path]}/NetAcuity_#{node['wt_netacuity']['version']}.tgz" do
  source "#{node['wt_netacuity']['download_url']}/NetAcuity_#{node['wt_netacuity']['version']}_#{node['kernel']['machine']}.tgz"
  mode 00644
  only_if do ! File.exists?("#{node['wt_netacuity']['install_dir']}/server/netacuity_server") end
end

# uncompress the install .tgz
execute "tar" do
  user  "root"
  group "root"
  cwd node['wt_netacuity']['install_dir']
  command "tar zxf #{Chef::Config[:file_cache_path]}/NetAcuity_#{node['wt_netacuity']['version']}.tgz"
  action :nothing
  subscribes :run, resources(:remote_file => "#{Chef::Config[:file_cache_path]}/NetAcuity_#{node['wt_netacuity']['version']}.tgz"), :immediately
end

# delete the netacuity tarball
execute "cleanup" do
  command "rm #{Chef::Config[:file_cache_path]}/NetAcuity_#{node['wt_netacuity']['version']}.tgz"
  action :nothing
  only_if do File.exists?("#{Chef::Config[:file_cache_path]}/NetAcuity_#{node['wt_netacuity']['version']}.tgz") end
  subscribes :run, resources(:execute => "tar")
end

# create the init script from a template
template "netacuity-init" do
  path "/etc/init.d/netacuity"
  source "netacuity.init.erb"
  owner "root"
  group "root"
  mode 00755
end

# enable the service and start it
service "netacuity" do
  enabled true
  running true
  pattern "netacuity_server"
  supports :status => false, :restart => true, :reload => false
  action [ :enable, :start ]
end

# create the config file from a template
template "netacuity-config" do
  path "#{node['wt_netacuity']['install_dir']}/server/netacuity.cfg"
  source "netacuity.cfg.erb"
  notifies :restart, resources(:service => "netacuity")
end

# grab the admin password from the data bag
auth_data = data_bag_item('authorization', node.chef_environment)
admin_password = auth_data['wt_netacuity']['admin_password']

# create the password file from a template
template "netacuity-passwd" do
  path "#{node['wt_netacuity']['install_dir']}/server/netacuity.passwd"
  source "netacuity.passwd.erb"
  variables(
    :admin_password => admin_password
  )
  notifies :restart, resources(:service => "netacuity")
end

if node.attribute?("nagios")
    #Create a nagios nrpe check to directly query netacuity for data using webtrends.com's IP
	nagios_nrpecheck "wt_netacuity_check" do
		command "#{node['nagios']['plugin_dir']}/check_netacuity.rb"
		parameters "localhost 216.223.23.5"
		action :add
	end

    #Copy in the nrpe netacuity check plugin config file.
	cookbook_file "#{node['nagios']['plugin_dir']}/check_netacuity.rb" do
		source "check_netacuity.rb"
		mode 00755
	end
    
    #Create a nagios nrpe check for the netacuity page
	nagios_nrpecheck "wt_netacuity_web_ui_check" do
		command "#{node['nagios']['plugin_dir']}/check_http"
		parameters "-H localhost -p 5500 -s \"Digital Envoy\""
		action :add
	end

	#Create a nagios nrpe command for the restart event handler
	nagios_nrpecheck "restart_netacuity" do
		command "#{node['nagios']['plugin_dir']}/restart_netacuity"
		action :add
	end

	#Copy in the event handler plugin
	cookbook_file "#{node['nagios']['plugin_dir']}/restart_netacuity" do
		source "restart_netacuity"
		mode 00755
	end

end