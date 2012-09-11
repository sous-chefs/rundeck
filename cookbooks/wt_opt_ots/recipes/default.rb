#
# Cookbook Name:: wt_opt_ots
# Recipe:: default
#
# Copyright 2012, Webtrends, Inc.
#
# All rights reserved - Do Not Redistribute
#

log "Deploy build is #{ENV["deploy_build"]}"
if ENV["deploy_build"] == "true" then
  log "The deploy_build value is true so un-deploy first"
  include_recipe "wt_streamingcollection::undeploy"
else
  log "The deploy_build value is not set or is false so we will only update the configuration"
end

log_dir      = File.join("#{node['wt_common']['log_dir_linux']}", "ots")
install_dir  = File.join("#{node['wt_common']['install_dir_linux']}", "ots")
tarball      = node['wt_opt_hornetq']['download_url'].split("/")[-1]

include_recipe "java"

if ENV["deploy_build"] == "true" then
  log "The deploy_build value is true so we will grab the tar ball and install"

end

