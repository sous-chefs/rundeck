#
# Author:: David Dvorak (<david.dvorak@webtrends.com>)
# Cookbook Name:: vc2010
# Recipe:: default
#
# Copyright 2012, Webtrends Inc.
#
# All rights reserved - Do Not Redistribute
#

if node['kernel']['machine'] =~ /x86_64/
	include_recipe "vc2010::vc2010x86"
	include_recipe "vc2010::vc2010x64"
else
	include_recipe "vc2010::vc2010x86"
end
