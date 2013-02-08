#
# Cookbook Name:: storm
# Recipe:: default
#
# Copyright 2012, Webtrends, Inc.
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

include_recipe "storm"

java_home = node['java']['java_home']
install_dir = "#{node['storm']['install_dir']}/storm-#{node['storm']['version']}"

if ENV["deploy_build"] == "true" then
  log "The deploy_build value is true so un-deploying first"
  include_recipe "storm::undeploy-supervisor"
end

%w{supervisor}.each do |daemon|
  # control file
  template "#{install_dir}/bin/#{daemon}-control" do
    source  "#{daemon}-control.erb"
    owner "root"
    group "root"
    mode  00755
    variables({
      :install_dir => install_dir,
      :log_dir => node['storm']['log_dir'],
      :java_home => java_home
    })
  end

  # runit service
  runit_service daemon do
    options({
      :install_dir => install_dir,
      :log_dir => node['storm']['log_dir'],
      :user => "storm"
    })
  end
end

service "servisor_start" do
  service_name "supervisor"
  action [:start]
end