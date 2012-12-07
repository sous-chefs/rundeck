#
# Author:: David Dvorak (<david.dvorak@webtrends.com>)
# Cookbook Name:: wt_base
# Recipe:: aptrepo
#
# Copyright 2012, Webtrends Inc.
#
# All rights reserved - Do Not Redistribute
#

node['wt_base']['apt'].each do |aptrepo|
  apt_repository aptrepo['name'] do
    repo_name aptrepo['name']
    distribution aptrepo['distribution']
    uri aptrepo['url']
    components aptrepo['components']
    action :add
  end
end