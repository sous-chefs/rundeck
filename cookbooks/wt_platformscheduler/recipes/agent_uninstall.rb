#
# Cookbook Name:: wt_platformscheduler
# Recipe:: agent_uninstall
# Author:: Kendrick Martin
#
# Copyright 2012, Webtrends Inc.
#
# All rights reserved - Do Not Redistribute
#
# This recipe uninstalls scheduler agent.
#

windows_package "WebtrendsVDMSchedulerAgent" do
	action :remove
	ignore_failure true
end
