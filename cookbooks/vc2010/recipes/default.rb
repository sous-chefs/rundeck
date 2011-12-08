#
# Author:: David Dvorak (<david.dvorak@webtrends.com>)
# Cookbook Name:: vc2010
# Recipe:: default
#
# Copyright 2011, Webtrends Inc.
#
# All rights reserved - Do Not Redistribute
#

include_recipe "vc2010::vc2010x86"

if node['kernel']['machine'] =~ /x86_64/
	include_recipe "vc2010::vc2010x64"
end
