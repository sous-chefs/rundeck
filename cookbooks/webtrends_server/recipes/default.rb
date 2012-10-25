#
# Cookbook Name:: webtrends_server
# Recipe:: default
#
# Copyright 2012, Webtrends Inc.
#
# All rights reserved - Do Not Redistribute
#

case node['platform_family']
  when "debian"
    include_recipe "webtrends_server::ubuntu"
  when "rhel"
    include_recipe "webtrends_server::centos"
  when "windows"
    include_recipe "webtrends_server::windows"
  else
    log "unknown platform family => #{node['platform_family']}"
end