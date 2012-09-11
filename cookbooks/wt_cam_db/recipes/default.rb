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

camdbuser = auth_data['wt_streamingconfigservice']['camdbuser']
camdbpwd  = auth_data['wt_streamingconfigservice']['camdbpwd']
camdbname = node['wt_cam']['db_name']
camdbhost = node['fqdn']
camdbport = node['wt_cam_db']['port']

domain         = node['authorization']['ad_auth']['ad_network']
installerlogin = auth_data['wt_common']['install_acct']
uilogin        = auth_data['wt_common']['ui_acct']
majorversion   = node['wt_cam_db']['major_version']
minorversion   = node['wt_cam_db']['minor_version']

download_url = node['wt_cam_db']['download_url']

if ENV["deploy_build"] then
  log "The deploy_build value is true, so we will grab the camdb zip and install"

  log "Camdbname: #{camdbname}"

  sql_server_database camdbname do
      connection ({:host => camdbhost,
                   :port => camdbport,
                   :username => camdbuser, 
                   :password => camdbpwd})
      action :drop 
  end

  windows_zipfile Chef::Config[:file_cache_path] do
    source download_url
    overwrite true
    action :unzip
  end

  log "Calling Deploy_CAM.bat #{camdbhost} #{camdbname} #{domain} #{installerlogin} #{uilogin} #{majorversion} #{minorversion}"

  execute "Deploy_CAM.bat" do
    cwd "#{Chef::Config[:file_cache_path]}/release"
    command "Deploy_CAM.bat #{camdbhost} #{camdbname} #{domain} #{installerlogin} #{uilogin} #{majorversion} #{minorversion}"
  end

end
