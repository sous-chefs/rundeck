#
# Cookbook Name:: stikked
# Recipe:: default
#
# Copyright 2013, Webtrends, Inc
#
# All rights reserved - Do Not Redistribute
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



auth_data = data_bag_item('authorization', node.chef_environment)
node.set['mysql']['server_root_password'] = auth_data['mysql']['server_root_password']

tarball     = node['stikked']['download_url'].split("/")[-1]
install_dir = node['stikked']['install_dir']
db_user     = auth_data['stikked']['db_user']
db_pass     = auth_data['stikked']['db_pass']


include_recipe "mysql::server"
include_recipe "apache2"
include_recipe "apache2::mod_php5"

mysql_connection_info = {:host => "localhost",
                         :username => 'root',
                         :password => node['mysql']['server_root_password']}

mysql_database_user db_user do
  connection mysql_connection_info
  password db_pass
  action :create
end

mysql_database node['stikked']['db_name'] do 
  connection mysql_connection_info
  action :create
end

remote_file "#{Chef::Config[:file_cache_path]}/#{tarball}" do
  source download_url
  mode 00644
  action :create_if_missing
end

# uncompress the application tarbarll into the install dir
execute "tar" do
 user  "root"
 group "root"
 cwd install_dir
 command "tar zxf #{Chef::Config[:file_cache_path]}/#{tarball}"
 action :nothing
 subscribes :run, "remote_file[#{Chef::Config[:file_cache_path]}/#{tarball}", :immediately
end

template "#{install_dir}/htdocs/application/config/stikked.php" do
	source "stkkked.php.erb"
	variables({
		:db_name => node['stikked']['db_name'],
		:db_user => db_user,
		:db_pass => db_pass
		})
	mode 00644
end

web_app "stikked" do
  server_name node['hostname']  
  docroot install_dir
end