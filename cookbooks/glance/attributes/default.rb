#
# Cookbook Name:: glance
# Attributes:: default
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

########################################################################
# Toggles - These can be overridden at the environment level
default["developer_mode"] = false  # we want secure passwords by default
########################################################################

default["glance"]["services"]["api"]["scheme"] = "http"    # node_attribute
default["glance"]["services"]["api"]["network"] = "public" # node_attribute
default["glance"]["services"]["api"]["port"] = 9292        # node_attribute
default["glance"]["services"]["api"]["path"] = "/v1"       # node_attribute

default["glance"]["services"]["registry"]["scheme"] = "http"    # node_attribute
default["glance"]["services"]["registry"]["network"] = "public" # node_attribute
default["glance"]["services"]["registry"]["port"] = 9191        # node_attribute
default["glance"]["services"]["registry"]["path"] = "/v1"       # node_attribute

default["glance"]["db"]["name"] = "glance"     # node_attribute
default["glance"]["db"]["username"] = "glance" # node_attribute

# TODO: These may need to be glance-registry specific.. and looked up by glance-api
default["glance"]["service_tenant_name"] = "service"                        # node_attribute
default["glance"]["service_user"] = "glance"                                # node_attribute
default["glance"]["service_role"] = "admin"                                 # node_attribute
default["glance"]["api"]["default_store"] = "file"                          # node_attribute
default["glance"]["api"]["swift"]["store_container"] = "glance"             # node_attribute
default["glance"]["api"]["swift"]["store_large_object_size"] = "200"        # node_attribute
default["glance"]["api"]["swift"]["store_large_object_chunk_size"] = "200"  # node_attribute
default["glance"]["api"]["cache"]["image_cache_max_size"] = "10737418240"   # node_attribute


# Default Image Locations
default["glance"]["image_upload"] = false                                                                                           # node_attribute
default["glance"]["images"] = [ "cirros" ]                                                                                          # node_attribute
default["glance"]["image"]["precise"] = "http://cloud-images.ubuntu.com/precise/current/precise-server-cloudimg-amd64-disk1.img"    # node_attribute
default["glance"]["image"]["oneiric"] = "http://cloud-images.ubuntu.com/oneiric/current/oneiric-server-cloudimg-amd64-disk1.img"    # node_attribute
default["glance"]["image"]["natty"] = "http://cloud-images.ubuntu.com/natty/current/natty-server-cloudimg-amd64-disk1.img"          # node_attribute
default["glance"]["image"]["cirros"] = "https://launchpadlibrarian.net/83305348/cirros-0.3.0-x86_64-disk.img"                       # node_attribute

# logging attribute
default["glance"]["syslog"]["use"] = false                  # node_attribute
default["glance"]["syslog"]["facility"] = "LOG_LOCAL2"      # node_attribute
default["glance"]["syslog"]["config_facility"] = "local2"   # node_attribute

# platform-specific settings
case platform
when "fedora", "redhat", "centos"
  default["glance"]["platform"] = {
    "mysql_python_packages" => [ "MySQL-python" ],                  # node_attribute
    "glance_packages" => [ "openstack-glance", "openstack-swift", "cronie" ], # node_attribute
    "glance_api_service" => "openstack-glance-api",                 # node_attribute
    "glance_registry_service" => "openstack-glance-registry",       # node_attribute
    "glance_api_process_name" => "glance-api",                      # node_attribute
    "package_overrides" => ""                                       # node_attribute
  }
when "ubuntu"
  default["glance"]["platform"] = {
    "mysql_python_packages" => [ "python-mysqldb" ],                # node_attribute
    "glance_packages" => [ "glance", "python-swift" ],              # node_attribute
    "glance_api_service" => "glance-api",                           # node_attribute
    "glance_registry_service" => "glance-registry",                 # node_attribute
    "glance_registry_process_name" => "glance-registry",            # node_attribute
    "package_overrides" => "-o Dpkg::Options::='--force-confold' -o Dpkg::Options::='--force-confdef'" # node_attribute
  }
end
