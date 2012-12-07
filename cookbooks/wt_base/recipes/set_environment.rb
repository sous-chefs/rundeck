#
# Author:: David Dvorak (<david.dvorak@webtrends.com>)
# Cookbook Name:: wt_base
# Recipe:: set_environment
#
# Copyright 2012, Webtrends Inc.
#
# All rights reserved - Do Not Redistribute
#

unless ENV['CHEF_ENVIRONMENT'].nil?
  log "changing environment #{node.chef_environment} to #{ENV['CHEF_ENVIRONMENT']}"
  node.chef_environment(ENV['CHEF_ENVIRONMENT'])
  node.save
end