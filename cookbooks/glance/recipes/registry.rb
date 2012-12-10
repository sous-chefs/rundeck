#
# Cookbook Name:: glance
# Recipe:: registry
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

::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)
include_recipe "mysql::client"
include_recipe "mysql::ruby"

platform_options = node["glance"]["platform"]

# Allow for using a well known db password
if node["developer_mode"]
  node.set_unless['glance']['db']['password'] = "glance"
else
  node.set_unless['glance']['db']['password'] = secure_password
end

# Set a secure keystone service password
node.set_unless['glance']['service_pass'] = secure_password

package "python-keystone" do
  action :install
end

ks_admin_endpoint = get_access_endpoint("keystone", "keystone", "admin-api")
ks_service_endpoint = get_access_endpoint("keystone", "keystone", "service-api")
keystone = get_settings_by_role("keystone", "keystone")

registry_endpoint = get_bind_endpoint("glance", "registry")

#creates db and user
#returns connection info
#defined in osops-utils/libraries
mysql_info = create_db_and_user("mysql",
  node["glance"]["db"]["name"],
  node["glance"]["db"]["username"],
  node["glance"]["db"]["password"])

package "curl" do
  action :install
end

platform_options["mysql_python_packages"].each do |pkg|
  package pkg do
    action :install
  end
end

platform_options["glance_packages"].each do |pkg|
  package pkg do
    action :upgrade
  end
end

service "glance-registry" do
  service_name platform_options["glance_registry_service"]
  supports :status => true, :restart => true
  action :enable
end

execute "glance-manage db_sync" do
  command "sudo -u glance glance-manage db_sync"
  action :nothing
  notifies :restart, resources(:service => "glance-registry"), :immediately
end

# Having to manually version the database because of Ubuntu bug
# https://bugs.launchpad.net/ubuntu/+source/glance/+bug/981111
execute "glance-manage version_control" do
  command "sudo -u glance glance-manage version_control 0"
  action :nothing
  not_if "sudo -u glance glance-manage db_version"
  notifies :run, resources(:execute => "glance-manage db_sync"), :immediately
  only_if { platform?(%w{ubuntu debian}) }
end

file "/var/lib/glance/glance.sqlite" do
  action :delete
end

# Register Service Tenant
keystone_register "Register Service Tenant" do
  auth_host ks_admin_endpoint["host"]
  auth_port ks_admin_endpoint["port"]
  auth_protocol ks_admin_endpoint["scheme"]
  api_ver ks_admin_endpoint["path"]
  auth_token keystone["admin_token"]
  tenant_name node["glance"]["service_tenant_name"]
  tenant_description "Service Tenant"
  tenant_enabled "true" # Not required as this is the default
  action :create_tenant
end

# Register Service User
keystone_register "Register Service User" do
  auth_host ks_admin_endpoint["host"]
  auth_port ks_admin_endpoint["port"]
  auth_protocol ks_admin_endpoint["scheme"]
  api_ver ks_admin_endpoint["path"]
  auth_token keystone["admin_token"]
  tenant_name node["glance"]["service_tenant_name"]
  user_name node["glance"]["service_user"]
  user_pass node["glance"]["service_pass"]
  user_enabled "true" # Not required as this is the default
  action :create_user
end

## Grant Admin role to Service User for Service Tenant ##
keystone_register "Grant 'admin' Role to Service User for Service Tenant" do
  auth_host ks_admin_endpoint["host"]
  auth_port ks_admin_endpoint["port"]
  auth_protocol ks_admin_endpoint["scheme"]
  api_ver ks_admin_endpoint["path"]
  auth_token keystone["admin_token"]
  tenant_name node["glance"]["service_tenant_name"]
  user_name node["glance"]["service_user"]
  role_name node["glance"]["service_role"]
  action :grant_role
end

directory "/etc/glance" do
  action :create
  group "glance"
  owner "glance"
  mode "0700"
end

template "/etc/glance/glance-registry.conf" do
  source "glance-registry.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  variables(
    "registry_bind_address" => registry_endpoint["host"],
    "registry_port" => registry_endpoint["port"],
    "db_ip_address" => mysql_info["bind_address"],
    "db_user" => node["glance"]["db"]["username"],
    "db_password" => node["glance"]["db"]["password"],
    "db_name" => node["glance"]["db"]["name"],
    "use_syslog" => node["glance"]["syslog"]["use"],
    "log_facility" => node["glance"]["syslog"]["facility"]
    )
  notifies :run, resources(:execute => "glance-manage version_control"), :immediately
end

template "/etc/glance/glance-registry-paste.ini" do
  source "glance-registry-paste.ini.erb"
  owner "root"
  group "root"
  mode "0644"
  variables(
    "keystone_api_ipaddress" => ks_admin_endpoint["host"],
    "keystone_service_port" => ks_service_endpoint["port"],
    "keystone_admin_port" => ks_admin_endpoint["port"],
    "service_tenant_name" => node["glance"]["service_tenant_name"],
    "service_user" => node["glance"]["service_user"],
    "service_pass" => node["glance"]["service_pass"]
    )
  notifies :restart, resources(:service => "glance-registry"), :immediately
end
