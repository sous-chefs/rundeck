#
# Cookbook Name:: mysql-openstack
# Recipe:: server
#
# Copyright 2012, Rackspace US, Inc.
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

include_recipe "osops-utils"

# Lookup endpoint info, and properly set mysql attributes
mysql_info = get_bind_endpoint("mysql", "db")
node.set["mysql"]["bind_address"] = mysql_info["host"]

# override this default attribute in the upstream mysql cookbooke
if platform?(%w{redhat centos amazon scientific})
    node.override["mysql"]["tunable"]["innodb_adaptive_flushing"] = false
end

# install the mysql gem
include_recipe "mysql::ruby"
# install the mysql server
include_recipe "mysql::server"

# Cleanup the craptastic mysql default users
cookbook_file "/tmp/cleanup_anonymous_users.sql" do
  source "cleanup_anonymous_users.sql"
  mode "0644"
end

execute "cleanup-default-users" do
  command "#{node['mysql']['mysql_bin']} -u root #{node['mysql']['server_root_password'].empty? ? '' : '-p' }\"#{node['mysql']['server_root_password']}\" < /tmp/cleanup_anonymous_users.sql"
  only_if "#{node['mysql']['mysql_bin']} -u root #{node['mysql']['server_root_password'].empty? ? '' : '-p' }\"#{node['mysql']['server_root_password']}\" -e 'show databases;' | grep test"
end

# Moving out of mysql cookbook
template "/root/.my.cnf" do
  source "dotmycnf.erb"
  owner "root"
  group "root"
  mode "0600"
  not_if "test -f /root/.my.cnf"
  variables :rootpasswd => node['mysql']['server_root_password']
end

platform_options = node["mysql"]["platform"]
