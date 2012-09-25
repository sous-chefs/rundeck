#
# Cookbook Name:: unbound
# Provider:: rr
#
# Copyright 2011, Joshua Timberman
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

def load_current_resource
  @rr = Chef::Resource::UnboundRr.new(new_resource.name)
  Chef::Log.debug("Checking for record #{new_resource.name}")
  exists = false
  @rr.exists(exists)
end

action :add do
  unless @rr.exists
  end
end
