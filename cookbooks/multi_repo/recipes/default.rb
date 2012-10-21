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
%w{ nfs-common reprepro createrepo apt-mirror gnupg rsync }.each do |pkg|
  package pkg
end

gem_package "builder" do
  action :install
end

# create the repo directory
directory node['multi_repo']['repo_path'] do
  action :create
end

# create the repo drop box directory
directory node['multi_repo']['repo_dropbox_path'] do
  action :create
end

# copy the gem files from dropbox to the repo
#execute "move gems" do
#  command "mv #{node['multi_repo']['repo_dropbox_path']}/*.gem #{node['multi_repo']['repo_path']}/gems/gems/"
#  action :run
#  only_if Dir.glob("#{node['multi_repo']['repo_dropbox_path']}/*.gem")
#end

# copy the rpm files from dropbox to the repo
#execute "move rpms" do
#  command "mv #{node['multi_repo']['repo_dropbox_path']}/*.rpm #{node['multi_repo']['repo_path']}/yum/centos/"
#  action :run
#  only_if Dir.glob("#{node['multi_repo']['repo_dropbox_path']}/*.rpm")
#end

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

# create the extra repo directories
node['multi_repo']['extra_repo_subdirs'].each do |dir|
  directory "#{node['multi_repo']['repo_path']}/#{dir}" do
    recursive true
    action :create
  end
end

# create the gem repo directory
directory "#{node['multi_repo']['repo_path']}/gems/gems" do
  recursive true
  action :create
end

# manage centos mirror if enabled
if node['multi_repo']['mirrors']['mirror_centos']

  directory "#{node['multi_repo']['repo_path']}/yum/centos" do
    recursive true
    action :create
  end

end


# manage apt mirror if enabled
if node['multi_repo']['mirrors']['mirror_ubuntu']

  # create the apt mirror directory
  directory "#{node['multi_repo']['repo_path']}/apt" do
    recursive true
    action :create
  end

  # template the apt mirror config
  template "/etc/apt/mirror.list" do
    source "mirror.list.erb"
    mode 00644
  end

end
