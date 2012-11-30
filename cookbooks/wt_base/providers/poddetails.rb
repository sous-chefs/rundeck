#
# Cookbook Name:: wt_base
# Provider:: poddetails
# Author:: David Dvorak (<david.dvorak@webtrends.com>)
#
# Copyright 2012, Webtrends Inc.
#
# All rights reserved - Do Not Redistribute
#

# include Chef::Mixin::ShellOut

action :run do
  return unless node['wt_base']['pod_details']
end