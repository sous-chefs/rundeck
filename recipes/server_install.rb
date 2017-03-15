#
# Cookbook Name:: rundeck
# Recipe::server_install
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
include_recipe 'rundeck::_data_bags'

if node.run_state['rundeck']['data_bag']['ldap']
  rundeck_ldap_bind_dn = node.run_state['rundeck']['data_bag']['ldap']['binddn']
  rundeck_ldap_bind_pwd = node.run_state['rundeck']['data_bag']['ldap']['bindpwd']
end
rundeck_ldap = node['rundeck']['ldap']

case node['platform_family']
when 'rhel'
  yum_repository 'rundeck' do
    description 'Rundeck - Release'
    url node['rundeck']['rpm']['repo']['url']
    gpgkey node['rundeck']['rpm']['repo']['gpgkey']
    gpgcheck node['rundeck']['rpm']['repo']['gpgcheck']
    action :add
  end

  rundeck_version = node['rundeck']['rpm']['version'].split('-')[1]

  yum_package 'rundeck' do
    version node['rundeck']['rpm']['version'].split('-')[1, 2].join('-')
    action :install
  end

  yum_package 'rundeck-config' do
    version node['rundeck']['rpm']['version'].split('-')[1, 2].join('-')
    allow_downgrade true
    action :install
  end
else
  remote_file "#{Chef::Config[:file_cache_path]}/#{node['rundeck']['deb']['package']}" do
    source node['rundeck']['url']
    owner node['rundeck']['user']
    group node['rundeck']['group']
    checksum node['rundeck']['checksum']
    mode '0644'
  end

  rundeck_version = node['rundeck']['deb']['package'].split('-')[1]

  package node['rundeck']['url'] do
    action :install
    source "#{Chef::Config[:file_cache_path]}/#{node['rundeck']['deb']['package']}"
    provider Chef::Provider::Package::Dpkg
    options node['rundeck']['deb']['options'] if node['rundeck']['deb']['options']
  end
  package uuidgen
end

service 'rundeck' do
  service_name 'rundeckd'
  provider Chef::Provider::Service::Upstart
  supports status: true, restart: true
  action :nothing
end

directory node['rundeck']['basedir'] do
  owner node['rundeck']['user']
  group node['rundeck']['group']
  recursive true
end

directory node['rundeck']['exec_logdir'] do
  owner node['rundeck']['user']
  group node['rundeck']['group']
  recursive true
end

directory "#{node['rundeck']['basedir']}/projects" do
  owner node['rundeck']['user']
  group node['rundeck']['group']
  recursive true
end

directory "#{node['rundeck']['basedir']}/.chef" do
  owner node['rundeck']['user']
  group node['rundeck']['group']
  recursive true
  mode '0700'
end

template "#{node['rundeck']['basedir']}/.chef/knife.rb" do
  owner node['rundeck']['user']
  group node['rundeck']['group']
  source 'knife.rb.erb'
  variables(
    user_home: node['rundeck']['basedir'],
    node_name: node['rundeck']['user'],
    chef_server_url: node['rundeck']['chef_url']
  )
  notifies (node['rundeck']['restart_on_config_change'] ? :restart : :nothing), 'service[rundeck]', :delayed
end

directory "#{node['rundeck']['basedir']}/.ssh" do
  owner node['rundeck']['user']
  group node['rundeck']['group']
  recursive true
  mode '0700'
end

file "#{node['rundeck']['basedir']}/.ssh/id_rsa" do
  owner node['rundeck']['user']
  group node['rundeck']['group']
  mode '0600'
  backup false
  content node.run_state['rundeck']['data_bag']['secure']['private_key']
  only_if { node.run_state['rundeck']['data_bag']['secure']['private_key'] }
  notifies (node['rundeck']['restart_on_config_change'] ? :restart : :nothing), 'service[rundeck]', :delayed
end

cookbook_file "#{node['rundeck']['basedir']}/libext/rundeck-winrm-plugin-1.3.3.jar" do
  owner node['rundeck']['user']
  group node['rundeck']['group']
  mode '0644'
  backup false
  source 'rundeck-winrm-plugin-1.3.3.jar'
  checksum 'dac57210e7a782d574621d5df27517bed4f58ebb54a40b9adab435333a5a5133'
  notifies (node['rundeck']['restart_on_config_change'] ? :restart : :nothing), 'service[rundeck]', :delayed
end

template "#{node['rundeck']['basedir']}/exp/webapp/WEB-INF/web.xml" do
  owner node['rundeck']['user']
  group node['rundeck']['group']
  variables(
    rundeck_version: rundeck_version
  )
  source 'web.xml.erb'
  notifies (node['rundeck']['restart_on_config_change'] ? :restart : :nothing), 'service[rundeck]', :delayed
end

template "#{node['rundeck']['configdir']}/jaas-activedirectory.conf" do
  owner node['rundeck']['user']
  group node['rundeck']['group']
  source 'jaas-activedirectory.conf.erb'
  variables(
    ldap: rundeck_ldap,
    binddn: rundeck_ldap_bind_dn || rundeck_ldap[:binddn],
    bindpwd: rundeck_ldap_bind_pwd || rundeck_ldap[:bindpwd],
    configdir: node['rundeck']['configdir'],
    rundeck_version: rundeck_version
  )
  notifies (node['rundeck']['restart_on_config_change'] ? :restart : :nothing), 'service[rundeck]', :delayed
end

template "#{node['rundeck']['configdir']}/profile" do
  owner node['rundeck']['user']
  group node['rundeck']['group']
  source 'profile.erb'
  variables(
    rundeck: node['rundeck'],
    rundeck_version: rundeck_version
  )
  notifies (node['rundeck']['restart_on_config_change'] ? :restart : :nothing), 'service[rundeck]', :delayed
end

template "#{node['rundeck']['configdir']}/rundeck-config.properties" do
  owner node['rundeck']['user']
  group node['rundeck']['group']
  source 'rundeck-config.properties.erb'
  variables(
    rundeck: node['rundeck'],
    rundeck_rdbms: node.run_state['rundeck']['data_bag']['rdbms']['rdbms']
  )
  notifies (node['rundeck']['restart_on_config_change'] ? :restart : :nothing), 'service[rundeck]', :delayed
end

template "/etc/init/rundeckd.conf" do
  owner 'root'
  group 'root'
  source 'rundeck-upstart.conf.erb'
  variables(
    config_dir: node['rundeck']['configdir']
  )
  notifies (node['rundeck']['restart_on_config_change'] ? :restart : :nothing), 'service[rundeck]', :delayed
  only_if { node['platform_family'] == 'debian'}
end

if node.normal['rundeck']['server']['uuid'].empty?
  node.normal['rundeck']['server']['uuid'] = RundeckHelper.generateuuid
end

template "#{node['rundeck']['configdir']}/framework.properties" do
  owner node['rundeck']['user']
  group node['rundeck']['group']
  source 'framework.properties.erb'
  variables(
    rundeck: node['rundeck'],
    rundeck_users: node.run_state['rundeck']['data_bag']['users']['users'],
    rundeck_uuid: node.normal['rundeck']['server']['uuid']
  )
  notifies (node['rundeck']['restart_on_config_change'] ? :restart : :nothing), 'service[rundeck]', :delayed
end

template "#{node['rundeck']['configdir']}/realm.properties" do
  owner node['rundeck']['user']
  group node['rundeck']['group']
  source 'realm.properties.erb'
  variables(
    rundeck_users: node.run_state['rundeck']['data_bag']['users']['users']
  )
end

if node.run_state['rundeck']['data_bag']['aclpolicies']
  node.run_state['rundeck']['data_bag']['aclpolicies']['aclpolicies'].each do |name, policy|
    template "#{node['rundeck']['configdir']}/#{name}.aclpolicy" do
      owner node['rundeck']['user']
      group node['rundeck']['group']
      source 'user.aclpolicy.erb'
      variables(
        aclpolicy: policy
      )
    end
  end
end

bash 'own rundeck' do
  user 'root'
  code <<-EOH
  chown -R #{node['rundeck']['user']}:#{node['rundeck']['group']} #{node['rundeck']['basedir']}
  EOH
end

service 'rundeckd' do
  action [:start, :enable]
  notifies :run, 'ruby_block[wait for rundeckd startup]', :immediately
end

ruby_block 'wait for rundeckd startup' do
  action :nothing
  block do
    # test connection to the authentication endpoint
    require 'uri'
    require 'net/http'
    uri = URI("#{node['rundeck']['grails_server_url']}:#{node['rundeck']['use_inbuilt_ssl']? node['rundeck']['ssl']['port'] : node['rundeck']['port']}")
    uri.path = ::File.join(node['rundeck']['webcontext'], '/j_security_check')
    res = Net::HTTP.get_response(uri)
    unless (200..399).include?(res.code.to_i)
      Chef::Log.warn { "#{res.uri} not responding healthy. #{res.code}" }
      Chef::Log.debug { res.body }
      raise
    end
    Chef::Log.info { 'wait a little longer for Rundeck startup' }
    sleep node['rundeck']['service']['extra_wait']
  end
  retries node['rundeck']['service']['retries']
  retry_delay node['rundeck']['service']['retry_delay']
end

Chef::Log.info { "chef-rundeck url: #{node['rundeck']['chef_rundeck_url']}" }

# Assuming node['rundeck']['plugins'] is a hash containing name=>attributes
unless node['rundeck']['plugins'].nil?
  node['rundeck']['plugins'].each do |plugin_name, plugin_attrs|
    rundeck_plugin plugin_name do
      url plugin_attrs['url']
      checksum plugin_attrs['checksum']
      action :create
    end
  end
end

include_recipe 'rundeck::_connect_rundeck_api_client'
include_recipe 'rundeck::_projects'
