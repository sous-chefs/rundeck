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


# Install packages needed to manage repos
%w{ nfs-common reprepro createrepo }.each do |pkg|
  package pkg
end

gem_package "builder" do
  action :install
end

# create the repo directories
%w{
"#{node['multi_repo']['repo_path']}"
"#{node['multi_repo']['repo_path']}/linux"
"#{node['multi_repo']['repo_path']}/product"
"#{node['multi_repo']['repo_path']}/windows"
"#{node['multi_repo']['repo_path']}/tools"
"#{node['multi_repo']['repo_path']}/yum"
"#{node['multi_repo']['repo_path']}/apt"
"#{node['multi_repo']['repo_path']}/gems"
}.each do |dir|
  directory dir do
    recursive true
    action :create
  end
end

# install apache2 to host the repo
include_recipe "apache2"

# disable the default apache site
apache_site "000-default" do
  enable false
end

# template the apache config for the repo site
template "#{node['apache']['dir']}/sites-available/repo" do
  source "apache2.conf.erb"
  mode 00644
  variables(:docroot => node['multi_repo']['repo_path'])
  if ::File.symlink?("#{node['apache']['dir']}/sites-enabled/repo")
    notifies :reload, resources(:service => "apache2")
  end
end

# mount the NFS mount on the repo
mount node['multi_repo']['repo_path'] do
  device node['multi_repo']['repo_mount']
  fstype "nfs"
  options "rw"
  action [:mount, :enable]
end

# create the apache site
apache_site "repo" do
  ignore_failure true
  enable true
end