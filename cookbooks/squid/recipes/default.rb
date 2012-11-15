#
# Author:: Matt Ray <matt@opscode.com>
# Cookbook Name:: squid
# Recipe:: default
#
# Copyright 2012, Opscode, Inc
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

package "squid" do
  action :install
end

case node['platform_family']
when "rhel","fedora","suse"
  template "/etc/sysconfig/squid" do
    source "redhat/sysconfig/squid.erb"
    notifies :restart, "service[squid]", :delayed
    mode 00644
  end
end

service "squid" do
  supports :restart => true, :status => true, :reload => true
  case node['platform_family']
  when "rhel","fedora","suse"
    provider Chef::Provider::Service::Redhat
  when "debian"
    provider Chef::Provider::Service::Upstart
  end
  service_name node['squid']['service_name']
  action [ :enable, :start ]
end

if node['squid']['network']
  network = node['squid']['network']
else
  network = node.ipaddress[0,node.ipaddress.rindex(".")]+".0/24"
end
Chef::Log.info "Squid network #{network}"

template "/etc/squid/squid.conf" do
  source "#{node['squid']['service_name']}.conf.erb"
  notifies :reload, "service[squid]"
  mode 00644
end

url_acl = []
begin
  data_bag("squid_urls").each do |bag|
    group = data_bag_item("squid_urls",bag)
    group['urls'].each do |url|
      url_acl.push [group['id'],url]
    end
  end
rescue
  Chef::Log.info "no 'squid_urls' data bag"
end

host_acl = []
begin
  data_bag("squid_hosts").each do |bag|
    group = data_bag_item("squid_hosts",bag)
    group['net'].each do |host|
      host_acl.push [group['id'],group['type'],host]
    end
  end
rescue
  Chef::Log.info "no 'squid_hosts' data bag"
end

acls = []
begin
  data_bag("squid_acls").each do |bag|
    group = data_bag_item("squid_acls",bag)
    group['acl'].each do |acl|
      acls.push [acl[1],group['id'],acl[0]]
    end
  end
rescue
  Chef::Log.info "no 'squid_acls' data bag"
end

template "/etc/#{node['squid']['service_name']}/chef.acl.config" do
  source "chef.acl.config.erb"
  variables(
    :acls => acls,
    :host_acl => host_acl,
    :url_acl => url_acl
    )
  notifies :reload, "service[squid]"
end

