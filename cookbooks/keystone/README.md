Description
===========

This cookbook installs the OpenStack Identity Service **Keystone** as part of the OpenStack **Essex** reference deployment Chef for OpenStack. The http://github.com/opscode/openstack-chef-repo contains documentation for using this cookbook in the context of a full OpenStack deployment. Keystone is installed from packages, creating the default user, tenant, and roles. It also registers the identity service and identity endpoint.

http://keystone.openstack.org/

Requirements
============

Chef 0.10.0 or higher required (for Chef environment use)

Platform
--------

* Ubuntu-12.04
* Fedora-17

Cookbooks
---------

The following cookbooks are dependencies:

* database
* mysql
* osops-utils

Resources/Providers
===================

These resources provide an abstraction layer for interacting with the keystone server's API, allowing for other nodes to register any required users, tenants, roles, services, or endpoints.

register
--------

Register users, tenants, roles, services and endpoints with Keystone

### Actions

- :create_tenant: Create a tenant
- :create_user: Create a user for a specified tenant
- :create_role: Create a role
- :grant_role: Grant a role to a specified user for a specified tenant
- :create_service: Create a service
- :create_endpoint: Create an endpoint for a sepcified service

### General Attributes

- auth_protocol: Required communication protocol with Keystone server
 - Acceptable values are [ "http", "https" ]
- auth_host: Keystone server IP Address
- auth_port: Port Keystone server is listening on
- api_ver: API Version for Keystone server
 - Accepted values are [ "/v2.0" ]
- auth_token: Auth Token for communication with Keystone server

### :create_tenant Specific Attributes

- tenant_name: Name of tenant to create
- tenant_description: Description of tenant to create
- tenant_enabled: Enable or Disable tenant
 - Accepted values are [ "true", "false" ]
 - Default is "true"

### :create_user Specific Attributes

- user_name: Name of user account to create
- user_pass: Password for the user account
- user_enabled: Enable or Disable user
 - Accepted values are [ "true", "false" ]
 - Default is "true"
- tenant_name: Name of tenant to create user in

### :create_role Specific Attributes

- role_name: Name of the role to create

### :grant_role Specific Attributes

- role_name: Name of the role to grant
- user_name: User name to grant the role to
- tenant_name: Name of tenant to grant role in

### :create_service Specific Attributes

- service_name: Name of service
- service_description: Description of service
- service_type: Type of service to create
 - Accepted values are [ "image", "identity", "compute", "storage", "ec2", "volume" ]

### :create_endpoint Specific Attributes

- endpoint_region: Default value is "RegionOne"
- endpoint_adminurl: URL to admin endpoint (using admin port)
- endpoint_internalurl: URL to service endpoint (using service port)
- endpoint_publicurl: URL to public endpoint
 - Default is same as endpoint_internalURL
- service_type: Type of service to create endpoint for
 - Accepted values are [ "image", "identity", "compute", "storage", "ec2", "volume" ]

### Examples

    # Create 'openstack' tenant
    keystone_register "Register 'openstack' Tenant" do
      auth_host "192.168.1.10"
      auth_port "35357"
      auth_protocol "http"
      api_ver "/v2.0"
      auth_token "123456789876"
      tenant_name "openstack"
      tenant_description "Default Tenant"
      tenant_enabled "true" # Not required as this is the default
      action :create_tenant
    end

    # Create 'admin' user
    keystone_register "Register 'admin' User" do
      auth_host "192.168.1.10"
      auth_port "35357"
      auth_protocol "http"
      api_ver "/v2.0"
      auth_token "123456789876"
      tenant_name "openstack"
      user_name "admin"
      user_pass "secrete"
      user_enabled "true" # Not required as this is the default
      action :create_user
    end

    # Create 'admin' role
    keystone_register "Register 'admin' Role" do
      auth_host "192.168.1.10"
      auth_port "35357"
      auth_protocol "http"
      api_ver "/v2.0"
      auth_token "123456789876"
      role_name role_key
      action :create_role
    end


    # Grant 'admin' role to 'admin' user in the 'openstack' tenant
    keystone_register "Grant 'admin' Role to 'admin' User" do
      auth_host "192.168.1.10"
      auth_port "35357"
      auth_protocol "http"
      api_ver "/v2.0"
      auth_token "123456789876"
      tenant_name "openstack"
      user_name "admin"
      role_name "admin"
      action :grant_role
    end

    # Create 'identity' service
    keystone_register "Register Identity Service" do
      auth_host "192.168.1.10"
      auth_port "35357"
      auth_protocol "http"
      api_ver "/v2.0"
      auth_token "123456789876"
      service_name "keystone"
      service_type "identity"
      service_description "Keystone Identity Service"
      action :create_service
    end

    # Create 'identity' endpoint
    keystone_register "Register Identity Endpoint" do
      auth_host "192.168.1.10"
      auth_port "35357"
      auth_protocol "http"
      api_ver "/v2.0"
      auth_token "123456789876"
      service_type "identity"
      endpoint_region "RegionOne"
      endpoint_adminurl "http://192.168.1.10:35357/v2.0"
      endpoint_internalurl "http://192.168.1.10:5001/v2.0"
      endpoint_publicurl "http://1.2.3.4:5001/v2.0"
      action :create_endpoint
    end

credentials
-----------

Create EC2 credentials for a given user in the specified tenant

### Actions

- :create_ec2: create EC2 credentials

### General Attributes

- auth_protocol: Required communication protocol with Keystone server. Acceptable values are [ "http", "https" ]
- auth_host: Keystone server IP Address
- auth_port: Port Keystone server is listening on
- api_ver: API Version for Keystone server
 - Accepted values are [ "/v2.0" ]
- auth_token: Auth Token for communication with Keystone server

### :create_ec2 Specific Attributes

- user_name: User name to grant the credentials for
- tenant_name: Tenant name to grant the credentials in

### Examples

    keystone_credentials "Create EC2 credentials for 'admin' user" do
      auth_host "192.168.1.10"
      auth_port "35357"
      auth_protocol "http"
      api_ver "/v2.0"
      auth_token "123456789876"
      user_name "admin"
      tenant_name "openstack"
    end

Recipes
=======

default
-------

The default recipe will install the Keystone Server

server
------

Installs the Keystone Server

Attributes
==========

* `keystone["db"]` - Name of keystone database
* `keystone["db_user"]` - Username for keystone database access
* `keystone["db_passwd"]` - Password for keystone database access
* `keystone["db_ipaddress"]` - IP address of the keystone database
* `keystone["api_ipaddress"]` - IP address for the keystone API to bind to. _TODO_: Rename to bind_address
* `keystone["verbose"]` - Enables/disables verbose output for keystone API server
* `keystone["debug"]` - Enables/disables debug output for keystone API server
* `keystone["service_port"]` - Port for the keystone service API to bind to
* `keystone["admin_port"]` - Port for the keystone admin service to bind to
* `keystone["admin_token"]` - Admin token for bootstraping keystone server
* `keystone["roles"]` - Array of roles to create in the keystone server
* `keystone["users"]` - Array of users to create in the keystone server

License and Author
==================

Author:: Justin Shepherd (<justin.shepherd@rackspace.com>)
Author:: Jason Cannavale (<jason.cannavale@rackspace.com>)
Author:: Ron Pedde (<ron.pedde@rackspace.com>)
Author:: Joseph Breu (<joseph.breu@rackspace.com>)
Author:: William Kelly (<william.kelly@rackspace.com>)
Author:: Darren Birkett (<darren.birkett@rackspace.co.uk>)
Author:: Evan Callicoat (<evan.callicoat@rackspace.com>)
Author:: Matt Ray (<matt@opscode.com>)

Copyright 2012, Rackspace US, Inc.
Copyright 2012, Opscode, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
