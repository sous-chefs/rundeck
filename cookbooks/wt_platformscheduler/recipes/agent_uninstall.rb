#
# Cookbook Name:: wt_platformscheduler
# Recipe:: agent_uninstall
# Author:: Kendrick Martin
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
# This recipe uninstalls scheduler agent


windows_package "Webtrends VDM Scheduler Agent" do
  action :remove
  ignore_failure true
end
