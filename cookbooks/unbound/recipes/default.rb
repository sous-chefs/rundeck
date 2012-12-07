#
# Cookbook Name:: unbound
# Recipe:: default
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

package "unbound" do
  action :install
end

directory "#{node['unbound']['directory']}/conf.d" do
  mode 0755
  owner "root"
  group root_group
end

template "#{node['unbound']['directory']}/unbound.conf" do
  source "unbound.conf.erb"
  mode 0644
  owner "root"
  group root_group
  notifies :reload, "service[unbound]"
end

# setup logfile
file "#{node['unbound']['logfile']}" do
  owner 'unbound'
  group 'unbound'
  mode 00755
  action :create_if_missing
end 

#begin
#  local_zone = data_bag_item("dns", node['dns']['domain'].gsub(/\./, "_"))
#rescue
#  local_zone = node['dns']['domain']
#end

#%w{ local forward stub }.each do |type|
%w{ forward stub }.each do |type|

  template "#{node['unbound']['directory']}/conf.d/#{type}-zone.conf" do
    source "#{type}-zone.conf.erb"
    mode 0644
    owner "root"
    group root_group
    # variables(:local_zone => local_zone)
    notifies :reload, "service[unbound]"
  end

end

# Not yet supported.
# include_recipe "unbound::remote_control" if node['unbound']['remote_control']['enable']

service "unbound" do
  supports :restart => true, :reload => true
  action [:enable, :start]
end
