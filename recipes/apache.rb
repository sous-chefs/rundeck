#
# Cookbook Name:: rundeck
# Recipe::apache
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

include_recipe 'apache2'
include_recipe 'apache2::mod_deflate'
include_recipe 'apache2::mod_headers'
include_recipe 'apache2::mod_ssl' if node['rundeck']['use_ssl']
include_recipe 'apache2::mod_proxy'
include_recipe 'apache2::mod_proxy_http'
include_recipe 'apache2::mod_rewrite'

if node['rundeck']['use_ssl']
  rundeck_ssl_secret = Chef::EncryptedDataBagItem.load_secret(node['rundeck']['secret_file']) # ~FC086
  rundeck_ssl_config = Chef::EncryptedDataBagItem.load(node['rundeck']['rundeck_databag'], node['rundeck']['rundeck_databag_certs'], rundeck_ssl_secret).to_hash # ~FC086

  file "#{node['apache']['dir']}/ssl/#{node['rundeck']['cert']['name']}.crt" do
    content rundeck_ssl_config['cert']
    notifies :restart, 'service[apache2]'
    not_if { ::File.exist?("#{node['apache']['dir']}/ssl/#{node['rundeck']['cert']['name']}.crt") }
  end

  file "#{node['apache']['dir']}/ssl/#{node['rundeck']['cert']['name']}.key" do
    content rundeck_ssl_config['key']
    notifies :restart, 'service[apache2]'
    not_if { ::File.exist?("#{node['apache']['dir']}/ssl/#{node['rundeck']['cert']['name']}.key") }
  end

  file "#{node['apache']['dir']}/ssl/#{node['rundeck']['cert']['ca_name']}.crt" do
    content rundeck_ssl_config['ca_cert']
    notifies :restart, 'service[apache2]'
    not_if { node['rundeck']['cert']['ca_name'].nil? }
    not_if { ::File.exist?("#{node['apache']['dir']}/ssl/#{node['rundeck']['cert']['ca_name']}.crt") }
  end

  java_certificate 'Install rundeck certificate to java truststore' do
    cert_data rundeck_ssl_config['cert']
    cert_alias node['rundeck']['cert']['name'].to_s
    only_if { node['rundeck']['cert']['ca_name'].nil? }
  end

  java_certificate 'Install ca certificate to java truststore' do
    cert_data rundeck_ssl_config['ca_cert']
    cert_alias node['rundeck']['cert']['ca_name']
    not_if { node['rundeck']['cert']['ca_name'].nil? }
  end

end

%w(default 000-default).each do |site|
  apache_site site do
    enable false
    notifies :reload, 'service[apache2]'
  end
end

template 'apache-config' do
  path "#{node['apache']['dir']}/sites-available/rundeck.conf"
  source 'rundeck.conf.erb'
  cookbook node['rundeck']['apache-template']['cookbook']
  mode 00644
  owner 'root'
  group 'root'
  variables(
    log_dir: node['platform_family'] == 'rhel' ? '/var/log/httpd' : '/var/log/apache2',
    doc_root: node['platform_family'] == 'rhel' ? '/var/www/html' : '/var/www'
  )
  notifies :reload, 'service[apache2]'
end

apache_site 'rundeck' do
  enable true
  notifies :reload, 'service[apache2]'
end

service 'apache2' do
  case node['platform_family']
  when 'rhel', 'fedora'
    service_name 'httpd'
  end
  subscribes :restart, 'service[rundeckd]', :immediately
end
