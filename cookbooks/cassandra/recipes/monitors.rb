#
# Author:: Timothy Smith (<tim.smith@webtrends.com>)
# Cookbook Name:: cassandra
# Recipe:: monitors
#
# Copyright 2012, Webtrends Inc.
#
# All rights reserved - Do Not Redistribute
#

#Create collectd plugin for cassandra if collectd has been applied.
if node.attribute?("collectd")
  template "#{node[:collectd][:plugin_conf_dir]}/collectd_cassandra.conf" do
    source "collectd_cassandra.conf.erb"
    owner "root"
    group "root"
    mode 00644
    notifies :restart, resources(:service => "collectd")
  end
end

# Add nagios checks if nagios is applied on the node
if node.attribute?("nagios")
	cookbook_file "#{node['nagios']['plugin_dir']}/cassandra_ring" do
		source "cassandra_ring"
		mode 00755
	end

  if node['cassandra']['cluster_chef_environments'].empty?
    alert_threshold= search(:node, "recipes:cassandra").count - 1
  else
   search_string= node['cassandra']['cluster_chef_environments'].map  { |env| "\(recipes:cassandra AND chef_environment:#{env}\)"}.join(" OR ")
   alert_threshold= search(:node, search_string).count - 1
  end
	nagios_nrpecheck "check_cassandra_ring" do
		command "sudo #{node['nagios']['plugin_dir']}/cassandra_ring"
		warning_condition "#{alert_threshold}"
    critical_condition "#{alert_threshold}"
		action :add
	end
end