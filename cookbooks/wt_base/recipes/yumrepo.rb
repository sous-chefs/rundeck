#
# Author:: David Dvorak (<david.dvorak@webtrends.com>)
# Cookbook Name:: wt_base
# Recipe:: yumrepo
#
# Copyright 2012, Webtrends Inc.
#
# All rights reserved - Do Not Redistribute
#

node['wt_base']['yum'].each do |yumrepo|
  yum_repository yumrepo['name'] do
    repo_name yumrepo['name']
    description yumrepo['description']
    url yumrepo['url']
    action :add
  end
end