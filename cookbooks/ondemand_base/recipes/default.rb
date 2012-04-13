#
# Cookbook Name:: ondemand_base
# Recipe:: default
#
# Copyright 2012, Webtrends Inc.
#
# All rights reserved - Do Not Redistribute
#

if platform?("centos", "redhat")
	include_recipe "ondemand_base::centos"
end

if platform?("debian", "ubuntu")
	include_recipe "ondemand_base::ubuntu"
end

if platform?("mswin", "mingw32", "windows")
	include_recipe "ondemand_base::windows"
end
