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

rundeck_secure = data_bag_item(node['rundeck']['rundeck_databag'], node['rundeck']['rundeck_databag_secure'])

if !node['rundeck']['secret_file'].nil? then
  rundeck_secret = Chef::EncryptedDataBagItem.load_secret(node['rundeck']['secret_file'])
  rundeck_secure = Chef::EncryptedDataBagItem.load(node['rundeck']['rundeck_databag'], node['rundeck']['rundeck_databag_secure'], rundeck_secret)
end  

case node['platform_family']
  when "rhel"
    repo = yum_repository "rundeck" do
      description "Rundeck - Release"
      url "http://dl.bintray.com/rundeck/rundeck-rpm"
      action :add
    end
    
    package "rundeck" do
      #version ""
      #options package_options
      action :install
    end 
  else 
    remote_file "#{Chef::Config[:file_cache_path]}/#{node['rundeck']['deb']}" do
      source node['rundeck']['url']
      owner node['rundeck']['user']
      group node['rundeck']['user']
      checksum node['rundeck']['checksum']
      mode "0644"
    end
    
    package node['rundeck']['url'] do
      action :install
      source "#{Chef::Config[:file_cache_path]}/#{node['rundeck']['deb']}"
      provider Chef::Provider::Package::Dpkg
    end
end


service "rundeck" do
  service_name "rundeckd"
  supports :status => true, :restart => true
  action :nothing
end


directory node['rundeck']['basedir'] do
  owner node['rundeck']['user']
  recursive true
end

directory "#{node['rundeck']['basedir']}/projects" do
  owner node['rundeck']['user']
  group node['rundeck']['user']
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
  notifies (node['rundeck']['restart_on_config_change'] ? :restart : :nothing), "service[rundeck]", :delayed
end

file "#{node['rundeck']['basedir']}/.ssh/id_rsa" do
  owner node['rundeck']['user']
  group node['rundeck']['user']
  mode "0600"
  backup false
  content rundeck_secure['private_key']
  only_if do !rundeck_secure['private_key'].nil? end
  notifies (node['rundeck']['restart_on_config_change'] ? :restart : :nothing), "service[rundeck]", :delayed
end

cookbook_file "#{node['rundeck']['basedir']}/libext/rundeck-winrm-plugin-1.1.jar" do
  owner node['rundeck']['user']
  group node['rundeck']['user']
  mode "0644"
  backup false
  source "rundeck-winrm-plugin-1.1.jar"
  notifies (node['rundeck']['restart_on_config_change'] ? :restart : :nothing), "service[rundeck]", :delayed
end

template "#{node['rundeck']['basedir']}/exp/webapp/WEB-INF/web.xml" do
  owner node['rundeck']['user']
  group node['rundeck']['user']
  source "web.xml.erb"
  notifies (node['rundeck']['restart_on_config_change'] ? :restart : :nothing), "service[rundeck]", :delayed
end

template "#{node['rundeck']['configdir']}/jaas-activedirectory.conf" do
  owner node['rundeck']['user']
  group node['rundeck']['user']
  source "jaas-activedirectory.conf.erb"
  variables(
    :ldap => node['rundeck']['ldap'],
    :configdir => node['rundeck']['configdir']
  )
  notifies (node['rundeck']['restart_on_config_change'] ? :restart : :nothing), "service[rundeck]", :delayed
end

template "#{node['rundeck']['configdir']}/profile" do
  owner node['rundeck']['user']
  group node['rundeck']['user']
  source "profile.erb"
  variables(
    :rundeck => node['rundeck']
  )
  notifies (node['rundeck']['restart_on_config_change'] ? :restart : :nothing), "service[rundeck]", :delayed
end


template "#{node['rundeck']['configdir']}/rundeck-config.properties" do
  owner node['rundeck']['user']
  group node['rundeck']['user']
  source "rundeck-config.properties.erb"
  variables(
    :rundeck => node['rundeck']
  )
  notifies (node['rundeck']['restart_on_config_change'] ? :restart : :nothing), "service[rundeck]", :delayed
end

template "#{node['rundeck']['configdir']}/framework.properties" do
  owner node['rundeck']['user']
  group node['rundeck']['user']
  source "framework.properties.erb"
  variables(
    :rundeck => node['rundeck']
  )
  notifies (node['rundeck']['restart_on_config_change'] ? :restart : :nothing), "service[rundeck]", :delayed
end

bash "own rundeck" do
  user "root"
  code <<-EOH
  chown -R #{node['rundeck']['user']}:#{node['rundeck']['user']} #{node['rundeck']['basedir']}
  EOH
end


apache_site "000-default" do
  enable false
  notifies :reload, "service[apache2]"
end


# load up the apache conf
template "apache-config" do
  path "#{node['apache']['dir']}/sites-available/rundeck.conf"
  source "rundeck.conf.erb"
  cookbook node['rundeck']['apache-template']['cookbook']
  mode 00644
  owner "root"
  group "root"
  variables(
    :log_dir => node['platform_family'] == 'rhel' ? "/var/log/httpd" : "/var/log/apache2",
    :doc_root => node['platform_family'] == 'rhel' ? "/var/www/html" : "/var/www"
  )
  notifies :reload, "service[apache2]"
end

apache_site "rundeck.conf" do
  notifies :reload, "service[apache2]"
end

# ensure rundeck is started
service "rundeckd" do
  action :start
end


#load projects
bags = data_bag(node['rundeck']['rundeck_projects_databag'])

projects = {}
bags.each do |project|
  pdata = data_bag_item(node['rundeck']['rundeck_projects_databag'], project)
  custom = ""
  if !pdata['project_settings'].nil? then
    pdata['project_settings'].map do |key, val|
     custom = custom + " --#{key}=#{val}"
    end
  end
  
  cmd = <<-EOH.to_s
  rd-project -p #{project} -a create \
  --resources.source.1.type=url \
  --resources.source.1.config.includeServerNode=true \
  --resources.source.1.config.generateFileAutomatically=true \
  --resources.source.1.config.url=#{pdata['chef_rundeck_url'].nil? ? node['rundeck']['chef_rundeck_url'] : pdata['chef_rundeck_url']}/#{project} \
  --project.resources.file=#{node['rundeck']['datadir']}/projects/#{project}/etc/resources.xml #{custom}
  EOH

  bash "check-project-#{project}" do
    user node['rundeck']['user']
    code cmd
    not_if do
      File.exists?("#{node['rundeck']['datadir']}/projects/#{project}/etc/project.properties")
    end
  end
end
