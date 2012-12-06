#
# Cookbook Name: wt_cam_db
# Recipe: default
# Author: Adam Sinnett(<adam.sinnet@webtrends.com>)
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute

#Properties
auth_data = data_bag_item('authorization', node.chef_environment)

camdbhost      = node['fqdn']
domain         = node['authorization']['ad_auth']['ad_network']
installerlogin = auth_data['wt_common']['camdb_install_user']
uilogin        = auth_data['wt_common']['ui_acct']

download_url = node['wt_cam_db']['download_url']

if ENV["deploy_build"] then
  log "The deploy_build value is true, so we will grab the camdb zip and install"

  log "Camdbname: #{camdbname}"

  windows_zipfile Chef::Config[:file_cache_path] do
    source download_url
    overwrite true
    action :unzip
  end

  log "Calling #{Chef::Config[:file_cache_path]}/release/Deploy_CAM.bat #{camdbhost} #{domain} #{installerlogin} #{uilogin}"

  execute "Deploy_CAM.bat" do
    cwd "#{Chef::Config[:file_cache_path]}/release"
    command "Deploy_CAM.bat #{camdbhost} #{domain} #{installerlogin} #{uilogin}"
    action :run
  end
end
