#
# Cookbook Name:: unbound
# Recipe:: remote_control
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

root_group = value_for_platform(
  "freebsd" => { "default" => "wheel" },
  "default" => "root"
)

node.set['unbound']['remote_control']['server_key'] =  File.join(node['unbound']['directory'], "unbound_server.key")
node.set['unbound']['remote_control']['server_cert'] =  File.join(node['unbound']['directory'], "unbound_server.pem")
node.set['unbound']['remote_control']['control_key'] =  File.join(node['unbound']['directory'], "unbound_control.key")
node.set['unbound']['remote_control']['control_cert'] =  File.join(node['unbound']['directory'], "unbound_control.pem")

template "#{node['unbound']['directory']}/conf.d/remote-control.conf" do
  source "remote-control.conf.erb"
  mode 0644
  owner "root"
  group root_group
  variables :control => node['unbound']['remote_control']
  notifies :restart, "service[unbound]"
end

execute "#{node['unbound']['bindir']}/unbound-control-setup" do
  not_if { ::File.exists?(node['unbound']['remote_control']['control_cert']) }
end
