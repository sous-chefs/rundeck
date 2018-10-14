#
# Cookbook Name:: rundeck
# Provider:: project
#
# Copyright 2012, Peter Crossley
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

action :create do
  new_resource.api_client.tap do |client|
    # Check if project is already on server
    if client.get('projects').select { |p| p['name'] == new_resource.name }.empty?
      # Create the project (with no config, config will be set below)
      converge_by "creating project #{new_resource.name}" do
        client.post('projects', name: new_resource.name)
      end
    end

    # Update project config
    # Creating a project with a POST to /projects creates the project with
    # the config provided _and_ additional default config. Updating the
    # project config with a PUT to /project/[PROJECT]/config does not leave
    # that additional default config. To handle this, always update the
    # project config to exactly what is provided to the lwrp.
    converge_by "updating config for project #{new_resource.name}" do
      client.put(
        ::File.join('project', new_resource.name, 'config'),
        new_resource.config.to_java_properties_hash
      )
    end
  end
end
