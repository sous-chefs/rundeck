#
# Cookbook Name:: nodedetails
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "apache2"
env_nodes = Array.new()
environments = Array.new()
web_user = node["apache"]["user"]
web_group = node["apache"]["group"] || web_user

directory "/var/nodedetails/environment" do
  recursive true
  action :create
  user web_user
  group web_group
end

apache_site "000-default" do
  enable false
end

template "#{node['apache']['dir']}/sites-available/nodedetails.conf" do
  source "site.conf.erb"
end

apache_site "nodedetails.conf"

search(:environment, "*:*") do |e|
  env_nodes = search(:node, "chef_environment:#{e}")
  template "/var/nodedetails/environment/#{e}.html" do
  	source "environment.html.erb"
  	variables(
      :nodes => env_nodes,
      :env_name => e 
  		)
    group web_group
    user web_user
  end
  environments << e
end

template "/var/nodedetails/index.html" do
  source "mainpage.html.erb"
  variables(
    :environments => environments
  	)
  group web_group
  user web_user
end