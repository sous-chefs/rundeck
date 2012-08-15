#
# Cookbook Name:: webtrends_server
# Recipe:: default
#
# Copyright 2012, Webtrends Inc.
#
# All rights reserved - Do Not Redistribute
#

case node.platform
	when "ubuntu", "debian"
		include_recipe "webtrends_server::ubuntu"
	when "centos", "redhat"
		include_recipe "webtrends_server::centos"
	when "windows", "mswin", "mingw32"
		include_recipe "webtrends_server::windows"
	else
		log "unknown platform => #{node.platform} #{node.platform_version}"
end