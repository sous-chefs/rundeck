#
# Cookbook Name:: wt_thumbnailcapture
# Recipe:: undeploy
#
# Copyright 2013, Webtrends
#
# All rights reserved - Do Not Redistribute
#

log_dir = File.join(node['wt_common']['log_dir_linux'], "thumbnailcapture")
install_dir = File.join(node['wt_common']['install_dir_linux'], "thumbnailcapture")
sv_dir = "/etc/sv/thumbnailcapture"
service_dir = "service/thumbnailservice"

runit_service "thumbnailcapture" do
    action :disable
end

# try to stop the service, but allow a failure without printing the error
service "thumbnailcapture" do
  action [:stop, :disable]
  ignore_failure true
end

service "screencap" do
  action [:stop, :disable]
  ignore_failure true
end

directory log_dir do
  recursive true
  action :delete
end

directory install_dir do
  recursive true
  action :delete
end

directory sv_dir do
  recursive true
  action :delete
end

directory service_dir do
  recursive true
  action :delete
end
