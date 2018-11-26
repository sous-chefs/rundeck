# frozen_string_literal: true
#
# Cookbook:: rundeck
# Resource:: apache
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

include RundeckCookbook::Helpers

property :use_ssl, [true, false], default: false
property :cert_name, String, default: lazy { node['hostname'] }
property :cert_contents, String
property :key_contents, String, sensitive: true
property :ca_cert_name, String
property :ca_cert_contents, String
property :hostname, String, default: lazy { "rundeck.#{node['domain']}" }
property :email, String, default: lazy { "rundeck@#{node['domain']}" }
property :allow_local_https,  [true, false], default: true
property :webcontext, String, default: '/'
property :port, Integer, default: 4440

action :install do
  include_recipe 'apache2'
  include_recipe 'apache2::mod_deflate'
  include_recipe 'apache2::mod_headers'
  include_recipe 'apache2::mod_ssl' if new_resource.use_ssl
  include_recipe 'apache2::mod_proxy'
  include_recipe 'apache2::mod_proxy_http'
  include_recipe 'apache2::mod_rewrite'

  if new_resource.use_ssl

    file "#{node['apache']['dir']}/ssl/#{new_resource.cert_name}.crt" do
      content new_resource.cert_contents
      notifies :restart, 'service[apache2]'
      not_if { ::File.exist?("#{node['apache']['dir']}/ssl/#{new_resource.cert_name}") }
    end

    file "#{node['apache']['dir']}/ssl/#{new_resource.cert_name}.key" do
      content new_resource.key_contents
      notifies :restart, 'service[apache2]'
      not_if { ::File.exist?("#{node['apache']['dir']}/ssl/#{new_resource.cert_name}.key") }
    end

    file "#{node['apache']['dir']}/ssl/#{new_resource.ca_cert_name}.crt" do
      content new_resource.ca_cert_contents
      notifies :restart, 'service[apache2]'
      not_if { new_resource.ca_cert_name.nil? }
      not_if { ::File.exist?("#{node['apache']['dir']}/ssl/#{new_resource.ca_cert_name}.crt") }
    end

    java_certificate 'Install rundeck certificate to java truststore' do
      cert_data new_resource.cert_contents
      cert_alias new_resource.cert_name.to_s
      only_if { new_resource.ca_cert_name.nil? }
    end

    java_certificate 'Install ca certificate to java truststore' do
      cert_data new_resource.ca_cert_contents
      cert_alias new_resource.ca_cert_name
      not_if { new_resource.ca_cert_name.nil? }
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
    cookbook 'rundeck'
    mode 00644
    owner 'root'
    group 'root'
    variables(
      log_dir: node['platform_family'] == 'rhel' ? '/var/log/httpd' : '/var/log/apache2',
      doc_root: node['platform_family'] == 'rhel' ? '/var/www/html' : '/var/www',
      use_ssl: new_resource.use_ssl,
      hostname: new_resource.hostname,
      email: new_resource.email,
      allow_local_https: new_resource.allow_local_https,
      cert_name: new_resource.cert_name,
      ca_cert_name: new_resource.ca_cert_name,
      webcontext: new_resource.webcontext,
      port: new_resource.port
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
end
