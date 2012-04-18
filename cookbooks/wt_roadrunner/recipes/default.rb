#
# Cookbook Name:: roadrunner
# Recipe:: default
# Author:: Kendrick Martin
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
# This recipe installs the needed components to full setup/configure the RoadRunner service


log "Deploy build is #{ENV["deploy_build"]}"
if ENV["deploy_build"] == "true" then # do we need to undeploy? 
include_recipe "wt_roadrunner::uninstall" # do we need to deploy? 
include_recipe "wt_roadrunner::install" 
end

service "wt_roadrunner" do
	action :start
end