#
# Author:: Kendrick Martin(<kendrick.martin@webtrends.com>)
# Cookbook Name:: webtrends_server
# Recipe:: updatechef
#
# Copyright 2012, Webtrends Inc.
#
# All rights reserved - Do Not Redistribute
#

new_version = "10.16.2"

if node['upgrade_chef'] == true
  node.set['upgrade_chef'] = false
  gem_package("chef") do
    version new_version
    action :install
  end

  if node.platform == "windows" then
    gem_package("ffi") do
      action :install
    end
  end
else
  log "Not upgrading chef"
end