#
# Cookbook Name:: wt_heatmaps
# Recipe:: apiserver
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
#

package "heatmaps" do
  version "#{node['wt_heatmaps']['heatmaps_version']}"
  options "--force-yes"
	action :install
end

thriftservers = Array.new
search(:node, "role:hadoop_datanode AND chef_environment:#{node.chef_environment}").each do |n|
    thriftservers << n[:fqdn]
end

template "/var/lib/php5/thriftservers.php" do
  source "apiserver/thriftservers.php"
  owner "www-data"
  group "www-data"
  mode "0744"
  variables(
    :thriftservers => thriftservers
  )
end

# setup webserver
template "#{node[:nginx][:dir]}/sites-available/apiserver" do
  source "apiserver/apiserver"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, resources(:service => "nginx")
end

remote_directory "/var/www" do
  source "apiserver-www"
  owner "www-data"
  group "www-data"
  files_owner "www-data"
  files_group "www-data"
  files_mode "0744"
  mode "0744"
end

nginx_site "default" do
  enable false
end

nginx_site "apiserver" do
  enable true
  notifies :restart, resources("service[nginx]","service[php-fastcgi]")
end