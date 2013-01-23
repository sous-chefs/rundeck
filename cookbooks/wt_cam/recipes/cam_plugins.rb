#
# Cookbook Name:: wt_cam
# Recipe:: cam_auth
# Author: Ivan von Nagy(<ivan.vonnagy@webtrends.com>)
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
# This recipe installs the plugins into the CAM site

#Properties
user_data = data_bag_item('authorization', node.chef_environment)
plugin_install_dir = "#{node['wt_common']['install_dir_windows']}\\Webtrends.Cam\\Plugins"

# Make sure the plugin directory exists
directory plugin_install_dir do
    recursive true
    action :create
end

# Make sure the security is correct
wt_base_icacls plugin_install_dir do
  action :grant
  user user_data['wt_common']['ui_user']
  perm :modify
end

template "#{plugin_install_dir}\\Webtrends.Cam.Plugins.Optimize.dll.config" do
  source "Webtrends.Cam.Plugins.Optimize.dll.config.erb"
  variables(
    :optimize_server_url => node['wt_cam']['optimize_plugin']['optimize_server_url'],
    :guest_user   => node['wt_cam']['optimize_plugin']['guest_user']
  )
end

if ENV["deploy_build"] == "true" then
  # Lay the files down
  windows_zipfile plugin_install_dir do
    source node['wt_cam']['cam_plugins']['download_url']
    action :unzip
    overwrite true
  end

  # Restart the CAM site
  iis_site 'CAM' do
    action [:restart]
  end
end
