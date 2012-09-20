#
# Cookbook Name:: gdash
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

include_recipe "apache2"

apache_site "000-default" do
  enable false
end

%w[ruby1.8-dev libapache2-mod-passenger].each do |pkg|
  apt_package pkg
end

#Grabbing and installing a newer version of rubygems since 1.3.5 comes with ubuntu/debian and a newer version is required.
remote_file "/usr/src/rubygems-1.3.7.tgz" do
  source "http://production.cf.rubygems.org/rubygems/rubygems-1.3.7.tgz"
  action :create_if_missing
end

execute "rubygems-1.3.7: untar" do
  command "tar zxf rubygems-1.3.7.tgz"
  creates "/usr/src/rubygems-1.3.7"
  cwd "/usr/src"
end

execute "install rubygems-1.3.7" do
  command "ruby setup.rb"
  cwd "/usr/src/rubygems-1.3.7"
  only_if "test $(gem -v) != \"1.3.7\""
end

#gem_package "bundler"

#bundler would not insatll using gem_package due to chef-client not seeing rubygems 1.3.7 so we are installing manually.
execute "install bundler gem" do
  command "gem install bundler"
  creates "/usr/bin/bundle"
end

execute "bundle_install" do
  command "bundle install"
  cwd node.gdash.base
  action :nothing
end

remote_file node.gdash.tarfile do
  mode "00666"
  owner node['apache']['user']
  group node['apache']['group']
  source node.gdash.url
  action :create_if_missing
end

directory node.gdash.base do
  owner node['apache']['user']
  group node['apache']['group']
end

directory node.gdash.templatedir do
  owner node['apache']['user']
  group node['apache']['group']
end

execute "gdash: untar" do
  command "tar zxf #{node.gdash.tarfile} -C #{node.gdash.base} --strip-components=1"
  creates File.join(node.gdash.base, "Gemfile.lock")
  user node['apache']['user']
  group node['apache']['group']
  notifies :run, resources(:execute => "bundle_install"), :immediately
end

template File.join(node.gdash.base, "config", "gdash.yaml") do
  mode 00644
  owner node['apache']['user']
  group node['apache']['group']
end

template "#{node['apache']['dir']}/sites-available/gdash" do
  source "gdash_apache2-conf.erb"
  mode 00644
  owner node['apache']['user']
  group node['apache']['group']
  variables(:docroot => File.join(node.gdash.base, "/public"))
end

#Enable the apache site
apache_site "gdash" do
  enable true
end
