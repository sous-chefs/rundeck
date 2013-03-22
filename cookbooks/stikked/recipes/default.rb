#
# Cookbook Name:: stikked
# Recipe:: default
#
# Copyright 2013, Kendrick Martin
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

gem_package "mysql"

auth_data = data_bag_item('authorization', node.chef_environment)
node.set['mysql']['server_root_password'] = auth_data['mysql']['server_root_password']

tarball     = node['stikked']['download_url'].split("/")[-1]
install_dir = "/opt/#{node['stikked']['version']}"
db_user     = auth_data['stikked']['db_user']
db_pass     = auth_data['stikked']['db_pass']


include_recipe "mysql::server"
include_recipe "apache2"
include_recipe "apache2::mod_php5"
include_recipe "apache2::mod_rewrite"

mysql_connection_info = {:host => "localhost",
                         :username => 'root',
                         :password => node['mysql']['server_root_password']}


directory install_dir

["php5-mysql", "php5-curl", "php5-gd", "php5-idn", "php-pear", "php5-imagick", "php5-imap", "php5-mcrypt", "php5-memcache", "php5-mhash",
 "php5-ming", "php5-ps", "php5-pspell", "php5-recode", "php5-snmp", "php5-sqlite", "php5-tidy", "php5-xmlrpc", "php5-xsl", "php5-json"].each do |p|
  package p
end

apache_site "000-default" do
  enable false
end

mysql_database node['stikked']['db_name'] do 
  connection mysql_connection_info
  action :create
end

mysql_database_user db_user do
  connection mysql_connection_info
  password db_pass
  database_name node['stikked']['db_name']
  privileges [:select,:update,:insert, :create, :delete]
  action [:create, :grant]
end

remote_file "#{Chef::Config[:file_cache_path]}/#{tarball}" do
  source node['stikked']['download_url']
  mode 00644
  action :create_if_missing
  notifies :run, "execute[tar]", :immediately
end

# uncompress the application tarbarll into the install dir
execute "tar" do
 user  "root"
 group "root"
 cwd "/opt"
 command "tar zxf #{Chef::Config[:file_cache_path]}/#{tarball}"
 action :nothing
end

template "#{install_dir}/htdocs/application/config/stikked.php" do
	source "stikked.php.erb"
	variables({
		:db_name => node['stikked']['db_name'],
		:db_user => db_user,
		:db_pass => db_pass
		})
	mode 00644
end

template "#{node['apache']['dir']}/sites-available/stikked.conf" do
  source "apache2.conf.erb"
  mode 00644
end

apache_site "stikked.conf"