#
# Author:: Kendrick Martin(<kendrick.martin@webtrends.com>)
# Cookbook Name:: wt_labstation
# Recipe:: windows
#
# Copyright 2012, Webtrends Inc.
#
# All rights reserved - Do Not Redistribute
#
# Sets up initial windows machine for use in a lab enviornment 

editor = node['wt_labstation']['editor']

env "EDITOR" do
  value editor
end
