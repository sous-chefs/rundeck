#
# Cookbook Name:: wt_netacuity
# Recipe:: default
#
# Copyright 2012, Webtrends
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

bags = data_bag('wop_server')
if !bags.include?(node[:wop_server][:env]) then
  Chef::Log.warn("wop-server: no databag configuration found for env: #{node[:wop_server][:env]}")
  return
end
wop_config = data_bag_item('wop_server', node[:wop_server][:env])

# netacuity.cfg contains the version number and needs to match 
# the version installed. If there's a version set in the databag
# use that otherwise take the defaults set here.
if wop_config['netacuity']['version'].nil?
  case node['kernel']['machine']
    when "i686"
    netacuity_version = "500" # 5.0
    when "x86_64"
    netacuity_version = "460" # 4.6
  end
  else
  netacuity_version = wop_config['netacuity']['version']
end

directory "/opt/NetAcuity"

cookbook_file "/opt/NetAcuity/NetAcuity.tgz" do
  source "NetAcuity_#{node[:kernel][:machine]}.tgz"
  action :nothing
  subscribes :create, resources(:directory => "/opt/NetAcuity"), :immediately
end


execute "unpack" do
  command "tar xvfz NetAcuity.tgz"
  cwd "/opt/NetAcuity"
  action :nothing
  subscribes :run, resources(:cookbook_file => "/opt/NetAcuity/NetAcuity.tgz"), :immediately
end

execute "cleanup" do
  command "rm NetAcuity.tgz"
  cwd "/opt/NetAcuity"
  action :nothing
  only_if do File.exists?("/opt/NetAcuity/NetAcuity.tgz") end
  subscribes :run, resources(:execute => "unpack")
end

cookbook_file "netacuity-init" do
  path "/etc/init.d/netacuity"
  source "netacuity.init"
  owner "root"
  group "root"
  mode "0744"
end

service "netacuity" do
  enabled true
  running true
  pattern "netacuity_server"
  supports :status => false, :restart => true, :reload => false
  action [ :enable, :start ]
end

template "netacuity-config" do
  path "/opt/NetAcuity/server/netacuity.cfg"
  source "netacuity/netacuity.cfg.erb"
  variables(
            :config => wop_config,
            :version => netacuity_version
            )
  notifies :restart, resources(:service => "netacuity")
end