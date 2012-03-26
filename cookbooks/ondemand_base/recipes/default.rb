#
# Cookbook Name:: ondemand_base
# Recipe:: default
#
# Copyright 2012, Webtrends Inc.
#
# All rights reserved - Do Not Redistribute
#

if platform?("centos", "redhat")
	include_recipe "centos"
end

if platform?("debian", "ubuntu")
	include_recipe "ubuntu"
end

if platform?("mswin", "mingw32", "windows")
	include_recipe "windows"
end
