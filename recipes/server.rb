#
# Cookbook Name:: rundeck
# Recipe::server
#
# Copyright 2012, Peter Crossley
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

include_recipe 'rundeck::default'
include_recipe 'java'
include_recipe "apache2"
include_recipe "apache2::mod_deflate"
include_recipe "apache2::mod_headers"
include_recipe "apache2::mod_ssl"
include_recipe "apache2::mod_proxy"
include_recipe "apache2::mod_proxy_http"



cookbook_file "/tmp/#{node[:rundeck][:deb]}" do
  source node[:rundeck][:deb]
  owner node[:rundeck][:user]
  group node[:rundeck][:user]
  mode "0644"
end

package "#{node[:rundeck][:deb]}" do
  action :install
  source "/tmp/#{node[:rundeck][:deb]}"
  provider Chef::Provider::Package::Dpkg
end

directory node['rundeck']['basedir'] do
  owner node['rundeck']['user']
  recursive true
end


directory "#{node['rundeck']['basedir']}/.chef" do
  owner node['rundeck']['user']
  group node['rundeck']['user']
  recursive true
  mode "0700"
end

template "#{node['rundeck']['basedir']}/.chef/knife.rb" do
  owner node['rundeck']['user']
  group node['rundeck']['user']
  source "knife.rb.erb"
  variables(
    :user_home => node['rundeck']['basedir'],
    :node_name => node['rundeck']['user'],
    :chef_server_url => node['rundeck']['chef_url']
  )
end

cookbook_file "#{node['rundeck']['basedir']}/.ssh/id_rsa" do
  owner node['rundeck']['user']
  group node['rundeck']['user']
  mode "0600"
  backup false
  source "rundeck"
end

cookbook_file "#{node['rundeck']['basedir']}/libext/rundeck-winrm-plugin-1.0-beta.jar" do
  owner node['rundeck']['user']
  group node['rundeck']['user']
  mode "0644"
  backup false
  source "rundeck-winrm-plugin-1.0-beta.jar"
end

template "#{node['rundeck']['configdir']}/jaas-activedirectory.conf" do
  owner node['rundeck']['user']
  group node['rundeck']['user']
  source "jaas-activedirectory.conf.erb"
  variables(
    :ldap => node['rundeck']['ldap'],
    :configdir => node['rundeck']['configdir']
  )
end

template "#{node['rundeck']['configdir']}/profile" do
  owner node['rundeck']['user']
  group node['rundeck']['user']
  source "profile.erb"
  variables(
    :rundeck => node['rundeck']
  )
end


template "#{node['rundeck']['configdir']}/rundeck-config.properties" do
  owner node['rundeck']['user']
  group node['rundeck']['user']
  source "rundeck-config.properties.erb"
  variables(
    :rundeck => node['rundeck']
  )
end


file "/etc/init.d/rundeckd" do
  action :delete
end

runit_service "rundeck" do
  options(
    :rundeck => node['rundeck']
  )
end

service "rundeck" do
  action :start
end

apache_site "000-default" do
  enable false
  notifies :reload, resources(:service => "apache2")
end


# load up the apache conf
template "apache-config" do
  path "#{node['apache']['dir']}/sites-available/rundeck.conf"
  source "rundeck.conf.erb"
  mode 00644
  owner "root"
  group "root"
  notifies :reload, resources(:service => "apache2")
end

apache_site "rundeck.conf" do
  notifies :reload, resources(:service => "apache2")
end



#load projects
bags = data_bag('rundeck')

projects = {}
bags.each do |project|
  pdata = data_bag_item('rundeck', project)

  execute "check-project-#{project}" do
    user node['rundeck']['user']
    command "/usr/bin/rd-project -p #{project} -a create"
    not_if do
      File.exists?("#{node['rundeck']['basedir']}/projects/#{project}/etc/project.properties")
    end
  end

  template "#{node['rundeck']['basedir']}/projects/#{project}/etc/project.properties" do
    source "project.properties.erb"
    owner node['rundeck']['user']
    group node['rundeck']['user']
    variables(
      :project => project,
      :data => pdata,
      :rundeck => node['rundeck']
    )
    only_if do
      File.exists?("#{node['rundeck']['basedir']}/projects/#{project}/etc")
    end
  end
end
