#
# Cookbook Name:: ms_messagequeue
# Recipe:: default
#
# Copyright 2012, Webtrends Inc.
#
# All rights reserved - Do Not Redistribute
#

#Install MSMQ server
	windows_feature "MSMQ-Server" do
	   action :install
	end