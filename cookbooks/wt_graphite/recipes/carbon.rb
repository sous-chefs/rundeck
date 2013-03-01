#
# Cookbook Name:: graphite
# Recipe:: carbon
#
# Copyright 2011, Heavy Water Software Inc.
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
version = node[:graphite][:version]
pyver = node[:graphite][:python_version]

remote_file "/usr/src/carbon-#{version}.tar.gz" do
  source node[:graphite][:carbon][:uri]
  checksum node[:graphite][:carbon][:checksum]
end

execute "untar carbon" do
  command "tar xzf carbon-#{version}.tar.gz"
  creates "/usr/src/carbon-#{version}"
  cwd "/usr/src"
end

execute "install carbon" do
  command "python setup.py install"
  creates "/opt/graphite/lib/carbon-#{version}-py#{pyver}.egg-info"
  cwd "/usr/src/carbon-#{version}"
end

service "carbon-cache" do
  supports :status => true, :start => true, :stop => true
end

#Create init script for RH or DEB
template "/etc/init.d/carbon-cache" do
  source "carbon-cache.init.erb"
  owner "root"
  group "root"
  mode 00755
  notifies :enable, "service[carbon-cache]"
  notifies :start, "service[carbon-cache]"
end

template "/opt/graphite/conf/carbon.conf" do
  owner node['apache']['user']
  group node['apache']['group']
  variables( :local_data_dir => node[:graphite][:carbon][:local_data_dir],
             :line_receiver_interface => node[:graphite][:carbon][:line_receiver_interface],
             :pickle_receiver_interface => node[:graphite][:carbon][:pickle_receiver_interface],
             :cache_query_interface => node[:graphite][:carbon][:cache_query_interface] )
  mode 00644
  notifies :restart, "service[carbon-cache]"
end

template "/opt/graphite/conf/storage-schemas.conf" do
  owner node['apache']['user']
  group node['apache']['group']
  mode 00644
end

execute "carbon: change graphite storage permissions to apache user" do
  command "chown -R #{node['apache']['user']}:#{node['apache']['group']} /opt/graphite/storage"
  only_if do
    f = File.stat("/opt/graphite/storage")
    f.uid == 0 and f.gid == 0
  end
end

directory "/opt/graphite/lib/twisted/plugins/" do
  owner node['apache']['user']
  group node['apache']['group']
end

service "carbon-cache" do
  action [:enable, :start]
end
