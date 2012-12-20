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

windows_package 'WebtrendsVDMSchedulerAgent-Uninstall' do
    package_name 'WebtrendsVDMSchedulerAgent'
	action :remove
	ignore_failure true
end