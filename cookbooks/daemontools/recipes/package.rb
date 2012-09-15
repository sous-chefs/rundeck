#
# Cookbook Name:: daemontools
# Recipe:: package
#
# Copyright 2010-2012, Opscode, Inc.
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

case node['platform_family']
when "debian"
  package "daemontools-run" do
    action :install
  end
else
  Chef::Log.info "Attempting package installation method of daemontools in #{cookbook_name}::#{recipe_name}."
  Chef::Log.info "If this fails, try node['daemontools']['install_method'] 'source'"

  package "daemontools" do
    action :install
  end
end

