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

unified_mode true

include RundeckCookbook::Helpers
include Apache2::Cookbook::Helpers

property :use_ssl, [true, false], default: false
property :cert_location, String, default: lazy { "#{apache_dir}/ssl" }
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
  apache2_install 'default_install'

  apache2_module 'deflate'
  apache2_module 'headers'
  apache2_module 'proxy'
  apache2_module 'proxy_http'
  apache2_module 'rewrite'

  if new_resource.use_ssl
    # until added to Apache2
    package 'mod_ssl' do
      action :install
      only_if { platform_family?('rhel', 'fedora', 'amazon') }
    end

    apache2_module 'ssl' do
      notifies :reload, 'apache2_service[rundeck]'
    end

    directory new_resource.cert_location do
      recursive true
    end

    file "#{new_resource.cert_location}/#{new_resource.cert_name}.crt" do
      content new_resource.cert_contents
      notifies :restart, 'apache2_service[rundeck]'
      not_if { ::File.exist?("#{new_resource.cert_location}/#{new_resource.cert_name}") }
    end

    file "#{new_resource.cert_location}/#{new_resource.cert_name}.key" do
      content new_resource.key_contents
      notifies :restart, 'apache2_service[rundeck]'
      action :create_if_missing
    end

    file "#{new_resource.cert_location}/#{new_resource.ca_cert_name}.crt" do
      content new_resource.ca_cert_contents
      notifies :restart, 'apache2_service[rundeck]'
      not_if { new_resource.ca_cert_name.nil? }
      action :create_if_missing
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
    apache2_site site do
      action :disable
      notifies :reload, 'apache2_service[rundeck]'
    end
  end

  template 'apache-config' do
    extend Apache2::Cookbook::Helpers
    path "#{apache_dir}/sites-available/rundeck.conf"
    source 'rundeck.conf.erb'
    cookbook 'rundeck'
    mode '644'
    owner 'root'
    group 'root'
    variables(
      log_dir: platform_family?('rhel', 'fedora', 'amazon') ? '/var/log/httpd' : '/var/log/apache2',
      doc_root: platform_family?('rhel', 'fedora', 'amazon') ? '/var/www/html' : '/var/www',
      use_ssl: new_resource.use_ssl,
      hostname: new_resource.hostname,
      email: new_resource.email,
      allow_local_https: new_resource.allow_local_https,
      cert_location: new_resource.cert_location,
      cert_name: new_resource.cert_name,
      ca_cert_name: new_resource.ca_cert_name,
      webcontext: new_resource.webcontext,
      port: new_resource.port
    )
  end

  apache2_site 'rundeck' do
    notifies :reload, 'apache2_service[rundeck]'
  end

  apache2_service 'rundeck' do
    action [:enable, :start]
    subscribes :restart, 'apache2_install[nagios]'
    subscribes :reload, 'apache2_module[deflate]'
    subscribes :reload, 'apache2_module[headers]'
    subscribes :reload, 'apache2_module[proxy]'
    subscribes :reload, 'apache2_module[proxy_http]'
    subscribes :reload, 'apache2_module[rewrite]'
    subscribes :restart, 'service[rundeckd]', :immediately
  end
end
