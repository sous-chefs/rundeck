#
# Cookbook Name:: ondemand_base
# Recipe:: default
#
# Copyright 2012, Webtrends Inc.
#
# All rights reserved - Do Not Redistribute
#

case node.platform
	when "ubuntu", "debian"
		include_recipe "ondemand_base::ubuntu"
	when "centos", "redhat"
		include_recipe "ondemand_base::centos"
	when "windows", "mswin", "mingw32"
		include_recipe "ondemand_base::windows"
	else
		log "unknown platform => #{node.platform} #{node.platform_version}"
end
