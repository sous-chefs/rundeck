#
# Cookbook Name:: nagios-xi
# Recipe:: default
#
# Copyright 2012, Webtrends Inc
#
# All rights reserved - Do Not Redistribute
#

#Install the prereqs for Nagios XI

if node.platform == "centos" 

%w{php-ldap procmail }.each do |pkg|
		package pkg do 
			action :install
		end
	end

end