#
# Cookbook Name:: keystone
# Provider:: credentials
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

action :create_ec2 do
    Chef::Log.debug("Keystone/Providers/Credentials.rb")
    Chef::Log.debug("Create_EC2 actions")

    # construct a HTTP object
    http = Net::HTTP.new(new_resource.auth_host, new_resource.auth_port)

    # Check to see if connection is http or https
    if new_resource.auth_protocol == "https"
        http.use_ssl = true
    end

    # Build out the required header info
    headers = _build_headers(new_resource.auth_token)

    # lookup tenant_uuid
    Chef::Log.debug("Looking up Tenant_UUID for Tenant_Name: #{new_resource.tenant_name}")
    tenant_container = "tenants"
    tenant_key = "name"
    tenant_path = "/#{new_resource.api_ver}/tenants"
    tenant_uuid, tenant_error = _find_id(http, tenant_path, headers, tenant_container, tenant_key, new_resource.tenant_name)
    Chef::Log.error("There was an error looking up Tenant '#{new_resource.tenant_name}'") if tenant_error

    # lookup user_uuid
    Chef::Log.debug("Looking up User_UUID for User_Name: #{new_resource.user_name}")
    user_container = "users"
    user_key = "name"
    user_path = "/#{new_resource.api_ver}/tenants/#{tenant_uuid}/users"
    user_uuid, user_error = _find_id(http, user_path, headers, user_container, user_key, new_resource.user_name)
    Chef::Log.error("There was an error looking up User '#{new_resource.user_name}'") if user_error

    Chef::Log.debug("Found Tenant UUID: #{tenant_uuid}")
    Chef::Log.debug("Found User UUID: #{user_uuid}")

    # See if a set of credentials already exists for this user/tenant combo
    cred_container = "credentials"
    cred_key = "tenant_id"
    cred_path = "/#{new_resource.api_ver}/users/#{user_uuid}/credentials/OS-EC2"
    cred_tenant_uuid, cred_error = _find_cred_id(http, cred_path, headers, cred_container, cred_key, tenant_uuid)
    Chef::Log.error("There was an error looking up EC2 Credentials for User '#{new_resource.user_name}' and Tenant '#{new_resource.tenant_name}'") if cred_error

    error = (tenant_error or user_error or cred_error)
    unless cred_tenant_uuid or error
        # Construct the extension path
        path = "/#{new_resource.api_ver}/users/#{user_uuid}/credentials/OS-EC2"

        payload = _build_credentials_obj(tenant_uuid)

        resp = http.send_request('POST', path, JSON.generate(payload), headers)
        if resp.is_a?(Net::HTTPOK)
            Chef::Log.info("Created EC2 Credentials for User '#{new_resource.user_name}' in Tenant '#{new_resource.tenant_name}'")
            # Need to parse the output here and update node attributes
            data = JSON.parse(resp.body)
            node.set['credentials']['EC2'][new_resource.user_name]['access'] = data['credential']['access']
            node.set['credentials']['EC2'][new_resource.user_name]['secret'] = data['credential']['secret']
            node.save unless Chef::Config[:solo]
            new_resource.updated_by_last_action(true)
        else
            Chef::Log.error("Unable to create EC2 Credentials for User '#{new_resource.user_name}' in Tenant '#{new_resource.tenant_name}'")
            Chef::Log.error("Response Code: #{resp.code}")
            Chef::Log.error("Response Message: #{resp.message}")
            new_resource.updated_by_last_action(false)
        end
    else
        Chef::Log.info("Credentials already exist for User '#{new_resource.user_name}' in Tenant '#{new_resource.tenant_name}'.. Not creating.")
        new_resource.updated_by_last_action(false)
    end
end


private
def _find_id(http, path, headers, container, key, match_value)
    uuid = nil
    error = false
    resp = http.request_get(path, headers)
    if resp.is_a?(Net::HTTPOK)
        data = JSON.parse(resp.body)
        data[container].each do |obj|
            uuid = obj['id'] if obj[key] == match_value
            break if uuid
        end
    else
        Chef::Log.error("Unknown response from the Keystone Server")
        Chef::Log.error("Response Code: #{resp.code}")
        Chef::Log.error("Response Message: #{resp.message}")
        error = true
    end
    return uuid,error
end


private
def _find_cred_id(http, path, headers, container, key, match_value)
    uuid = nil
    error = false
    resp = http.request_get(path, headers)
    if resp.is_a?(Net::HTTPOK)
        data = JSON.parse(resp.body)
        data[container].each do |obj|
            uuid = obj['tenant_id'] if obj[key] == match_value
            break if uuid
        end
    else
        Chef::Log.error("Unknown response from the Keystone Server")
        Chef::Log.error("Response Code: #{resp.code}")
        Chef::Log.error("Response Message: #{resp.message}")
        error = true
    end
    return uuid,error
end

private
def _build_credentials_obj(tenant_uuid)
    ret = Hash.new
    ret.store("tenant_id", tenant_uuid)
    return ret
end


private
def _build_headers(token)
    ret = Hash.new
    ret.store('X-Auth-Token', token)
    ret.store('Content-type', 'application/json')
    ret.store('user-agent', 'Chef keystone_credentials')
    return ret
end
