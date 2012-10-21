#
# Cookbook Name:: wt_monitoring
# Recipe:: chef_handler_graphite
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
#
# This recipe is used to add test traffic to the Optimize opsmon accounts.
# We use this test data to confirm that data processing is functioning as expected.
#

gem_package "chef-handler-graphite" do
  action :nothing
end.run_action(:install)

argument_array = [
  :metric_key => "#{node['wt_monitoring']['metric_prefix']}.#{node['hostname']}.chef_client",
  :graphite_host => "#{node['wt_monitoring']['graphite_server']}",
  :graphite_port => node['wt_monitoring']['graphite_port']
]

chef_handler "GraphiteReporting" do
  source "#{Gem::Specification.find_by_name('chef-handler-graphite').lib_dirs_glob}/chef-handler-graphite.rb"
  arguments argument_array
  action :nothing
end.run_action(:enable)
