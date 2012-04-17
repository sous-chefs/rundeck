#
# Cookbook Name:: wt_labstation
# Recipe:: default
#
# Copyright 2012, Webtrends Inc.
#
# All rights reserved - Do Not Redistribute
#

case node.platform
	when "ubuntu", "debian"		
	when "centos", "redhat"		
	when "windows", "mswin", "mingw32"
		include_recipe "wt_labstation::windows"
	else
		log "unknown platform => #{node.platform} #{node.platform_version}"
end
