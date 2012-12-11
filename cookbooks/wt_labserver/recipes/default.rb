#
# Cookbook Name:: wt_labserver
# Recipe:: default
#
# Copyright 2012, Webtrends Inc.
#
# All rights reserved - Do Not Redistribute
#

case node['platform_family']
  when 'debian'
    include_recipe 'wt_labserver::ubuntu'
  when 'rhel'
    include_recipe 'wt_labserver::centos'
  when 'windows'
    include_recipe 'wt_labserver::windows'
  else
    log "unknown platform family => #{node['platform_family']}"
end
