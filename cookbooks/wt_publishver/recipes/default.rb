#
# Cookbook Name:: wt_publishver
# Recipe:: default
#
# Copyright 2012, Webtrends Inc.
#
# All rights reserved - Do Not Redistribute
#

case node['platform_family']
  when 'debian', 'rhel'
    include_recipe 'wt_publishver::linux'
  when 'windows'
    include_recipe 'wt_publishver::windows'
  else
    log "unknown platform family => #{node['platform_family']}"
end
