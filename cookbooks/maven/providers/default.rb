#
# Cookbook Name:: maven
# Provider::      default
# Author:: Bryan W. Berry <bryan.berry@gmail.com>
# Copyright 2011, Opscode Inc.
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
require 'chef/mixin/shell_out'
include Chef::Mixin::ShellOut

def create_command_string(artifact_file, new_resource)
  group_id = "-DgroupId=" + new_resource.group_id
  artifact_id = "-DartifactId=" + new_resource.artifact_id
  version = "-Dversion=" + new_resource.version
  dest = "-Ddest=" + artifact_file
  repos = "-DremoteRepositories=" + new_resource.repositories.join(',')
  packaging = "-Dpackaging=" + new_resource.packaging
  plugin_version = '2.4'
  plugin = "org.apache.maven.plugins:maven-dependency-plugin:#{plugin_version}:get"
  %Q{mvn #{plugin} #{group_id} #{artifact_id} #{version} #{packaging} #{dest} #{repos}}
end

def get_mvn_artifact(action, new_resource)
  if action == "put"
    artifact_file = ::File.join new_resource.dest, "#{new_resource.name}.#{new_resource.packaging}"
  else
    artifact_file = ::File.join new_resource.dest, "#{new_resource.artifact_id}-#{new_resource.version}.#{new_resource.packaging}"
  end

  unless ::File.exists?(artifact_file)

    directory new_resource.dest do
      recursive true
      mode 00755
    end.run_action(:create)

    shell_out!(create_command_string(artifact_file, new_resource))

    file artifact_file do
      owner new_resource.owner
      group new_resource.owner
      mode new_resource.mode
    end.run_action(:create)

    new_resource.updated_by_last_action(true)

  end
end

action :install do
  get_mvn_artifact("install", new_resource)
end

action :put do
  get_mvn_artifact("put", new_resource)
end
