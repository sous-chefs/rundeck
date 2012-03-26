#
# Cookbook Name:: rundeck
# Recipe::server
#
# Copyright 2011, Peter Crossley
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

package "rundeck" do
  action :install
end


directory "#{node[:rundeck][:user_home]}/.ssh" do
  owner node[:rundeck][:user]
  group node[:rundeck][:user]
  recursive true
  mode "0700"
end

cookbook_file "#{node[:rundeck][:user_home]}/.ssh/id_rsa" do
  owner node[:rundeck][:user]
  group node[:rundeck][:user]
  mode "0600"
  backup false
  source "rundeck"
end


template "#{node[:rundeck][:configdir]}/jaas-activedirectory.conf" do
  owner node[:rundeck][:user]
  group node[:rundeck][:user]
  source "jaas-activedirectory.conf.erb"
  variables(
    :ldap => node[:rundeck][:ldap]
  )
end

template "#{node[:rundeck][:configdir]}/profile" do
  owner node[:rundeck][:user]
  group node[:rundeck][:user]
  source "profile.erb"
  variables(
    :rundeck => node[:rundeck]
  )
end


file "/etc/init.d/rundeckd" do
  action :delete
end

runit_service "rundeck" do
  run_restart false
  options(
    :rundeck => node[:rundeck]
  )
end

service "rundeck" do
  action :start
end


# load up the apache conf
template "apache-config" do
  path "#{node[:apache][:dir]}/sites-available/rundeck.conf"
  source "rundeck.conf.erb"
  mode 0644
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
    user node[:rundeck][:user]
    command "/usr/bin/rd-project -p #{project} -a create"
    not_if do
      File.exists?("#{node[:rundeck][:basedir]}/projects/#{project}/etc/project.properties")
    end 
  end
  
  template "#{node[:rundeck][:basedir]}/projects/#{project}/etc/project.properties" do
    source "project.properties.erb"
    owner node[:rundeck][:user]
    group node[:rundeck][:user]
    variables(
      :project => project,
      :data => pdata,
      :rundeck => node[:rundeck]
    )
    only_if do
      File.exists?("#{node[:rundeck][:basedir]}/projects/#{project}/etc")
    end
  end
end
