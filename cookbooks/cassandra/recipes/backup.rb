#
# Cookbook Name:: cassandra
# Recipe:: backup
#
# Copyright 2012, Tim Smith - Webtrends, Inc.
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

package "nfs-common"

directory node['cassandra']['backup']['mount_path'] do
	action :create
end

mount node['cassandra']['backup']['mount_path'] do
  device node['cassandra']['backup']['backup_nfs_mount']
  fstype "nfs"
  options "rw"
  action [:mount, :enable]
end

directory "#{node['cassandra']['backup']['mount_path']}/#{node['fqdn']}" do
  action :create
  recursive true
end

template "/usr/sbin/cassandra_backup.sh" do
  source "cassandra_backup.sh.erb"
  mode 00755
  owner "root"
  group "root"
end

cron "backup_cassandra" do
  hour "0"
  minute "1"
  command "/usr/sbin/cassandra_backup.sh"
  action :create
end