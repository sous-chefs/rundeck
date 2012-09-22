#
# Cookbook Name:: multi_repo
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


# include the vsftp cookbook
include_recipe "vsftpd"

# create the mount directory
directory node['wt_lfm_ftp']['lfm_mount_path'] do
  recursive true
end

# mount the NFS export onto the mount directory
mount node['wt_lfm_ftp']['repo_path'] do
  device node['wt_lfm_ftp']['lfm_nfs_export']
  fstype "nfs"
  options "rw"
  action [:mount, :enable]
end