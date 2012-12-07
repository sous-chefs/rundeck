#
# Cookbook Name:: keystone
# Recipe:: server
#
# Copyright 2012, Rackspace US, Inc.
# Copyright 2012, Opscode, Inc.
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
include_recipe "osops-utils"

# Allow for using a well known db password
if node["developer_mode"]
  node.set_unless["keystone"]["db"]["password"] = "keystone"
  node.set_unless["keystone"]["admin_token"] = "999888777666"
else
  node.set_unless["keystone"]["db"]["password"] = secure_password
  node.set_unless["keystone"]["admin_token"] = secure_password
end

platform_options = node["keystone"]["platform"]

#creates db and user, returns connection info, defined in osops-utils/libraries
mysql_info = create_db_and_user("mysql",
                                node["keystone"]["db"]["name"],
                                node["keystone"]["db"]["username"],
                                node["keystone"]["db"]["password"])

##### NOTE #####
# https://bugs.launchpad.net/ubuntu/+source/keystone/+bug/931236
################

platform_options["mysql_python_packages"].each do |pkg|
  package pkg do
    action :install
  end
end

platform_options["keystone_packages"].each do |pkg|
  package pkg do
    action :upgrade
    options platform_options["package_options"]
  end
end

execute "Keystone: sleep" do
  command "sleep 10s"
  action :nothing
end

service "keystone" do
  service_name platform_options["keystone_service"]
  supports :status => true, :restart => true
  action [ :enable ]
  notifies :run, resources(:execute => "Keystone: sleep"), :immediately
end

directory "/etc/keystone" do
  action :create
  owner "root"
  group "root"
  mode "0755"
end

file "/var/lib/keystone/keystone.db" do
  action :delete
end

execute "keystone-manage db_sync" do
  command "keystone-manage db_sync"
  action :nothing
end

ks_admin_endpoint = get_bind_endpoint("keystone", "admin-api")
ks_service_endpoint = get_bind_endpoint("keystone", "service-api")

template "/etc/keystone/keystone.conf" do
  source "keystone.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  variables(
            :debug => node["keystone"]["debug"],
            :verbose => node["keystone"]["verbose"],
            :user => node["keystone"]["db"]["username"],
            :passwd => node["keystone"]["db"]["password"],
            :ip_address => ks_admin_endpoint["host"],
            :db_name => node["keystone"]["db"]["name"],
            :db_ipaddress => mysql_info["bind_address"],
            :service_port => ks_service_endpoint["port"],
            :admin_port => ks_admin_endpoint["port"],
            :admin_token => node["keystone"]["admin_token"],
            :use_syslog => node["keystone"]["syslog"]["use"],
            :log_facility => node["keystone"]["syslog"]["facility"]
            )
  notifies :run, resources(:execute => "keystone-manage db_sync"), :immediately
  notifies :restart, resources(:service => "keystone"), :immediately
end

template "/etc/keystone/logging.conf" do
  source "keystone-logging.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, resources(:service => "keystone"), :immediately
end

#TODO(shep): this should probably be derived from keystone.users hash keys
node["keystone"]["tenants"].each do |tenant_name|
  ## Add openstack tenant ##
  keystone_register "Register '#{tenant_name}' Tenant" do
    auth_host ks_admin_endpoint["host"]
    auth_port ks_admin_endpoint["port"]
    auth_protocol ks_admin_endpoint["schema"]
    api_ver ks_admin_endpoint["path"]
    auth_token node["keystone"]["admin_token"]
    tenant_name tenant_name
    tenant_description "#{tenant_name} Tenant"
    tenant_enabled "true" # Not required as this is the default
    action :create_tenant
  end
end

## Add Roles ##
node["keystone"]["roles"].each do |role_key|
  keystone_register "Register '#{role_key.to_s}' Role" do
    auth_host ks_admin_endpoint["host"]
    auth_port ks_admin_endpoint["port"]
    auth_protocol ks_admin_endpoint["schema"]
    api_ver ks_admin_endpoint["path"]
    auth_token node["keystone"]["admin_token"]
    role_name role_key
    action :create_role
  end
end

node["keystone"]["users"].each do |username, user_info|
  keystone_register "Register '#{username}' User" do
    auth_host ks_admin_endpoint["host"]
    auth_port ks_admin_endpoint["port"]
    auth_protocol ks_admin_endpoint["schema"]
    api_ver ks_admin_endpoint["path"]
    auth_token node["keystone"]["admin_token"]
    user_name username
    user_pass user_info["password"]
    tenant_name user_info["default_tenant"]
    user_enabled "true" # Not required as this is the default
    action :create_user
  end

  user_info["roles"].each do |rolename, tenant_list|
    tenant_list.each do |tenantname|
      keystone_register "Grant '#{rolename}' Role to '#{username}' User in '#{tenantname}' Tenant" do
        auth_host ks_admin_endpoint["host"]
        auth_port ks_admin_endpoint["port"]
        auth_protocol ks_admin_endpoint["schema"]
        api_ver ks_admin_endpoint["path"]
        auth_token node["keystone"]["admin_token"]
        user_name username
        role_name rolename
        tenant_name tenantname
        action :grant_role
      end
    end

  end
end

## Add Services ##

keystone_register "Register Identity Service" do
  auth_host ks_admin_endpoint["host"]
  auth_port ks_admin_endpoint["port"]
  auth_protocol ks_admin_endpoint["schema"]
  api_ver ks_admin_endpoint["path"]
  auth_token node["keystone"]["admin_token"]
  service_name "keystone"
  service_type "identity"
  service_description "Keystone Identity Service"
  action :create_service
end

## Add Endpoints ##

node["keystone"]["adminURL"] = ks_admin_endpoint["uri"]
node["keystone"]["internalURL"] = ks_service_endpoint["uri"]
node["keystone"]["publicURL"] = ks_service_endpoint["uri"]

Chef::Log.info "Keystone AdminURL: #{ks_admin_endpoint["uri"]}"
Chef::Log.info "Keystone InternalURL: #{ks_service_endpoint["uri"]}"
Chef::Log.info "Keystone PublicURL: #{ks_service_endpoint["uri"]}"

keystone_register "Register Identity Endpoint" do
  auth_host ks_admin_endpoint["host"]
  auth_port ks_admin_endpoint["port"]
  auth_protocol ks_admin_endpoint["schema"]
  api_ver ks_admin_endpoint["path"]
  auth_token node["keystone"]["admin_token"]
  service_type "identity"
  endpoint_region "RegionOne"
  endpoint_adminurl node["keystone"]["adminURL"]
  endpoint_internalurl node["keystone"]["internalURL"]
  endpoint_publicurl node["keystone"]["publicURL"]
  action :create_endpoint
end


node["keystone"]["users"].each do |username, user_info|
  keystone_credentials "Create EC2 credentials for '#{username}' user" do
    auth_host ks_admin_endpoint["host"]
    auth_port ks_admin_endpoint["port"]
    auth_protocol ks_admin_endpoint["schema"]
    api_ver ks_admin_endpoint["path"]
    auth_token node["keystone"]["admin_token"]
    user_name username
    tenant_name user_info["default_tenant"]
  end
end
