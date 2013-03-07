#
# Cookbook Name:: wt_streaming_barebones
# Recipe:: default
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
#
 
# include runit so we can create a runit service
include_recipe "runit"
 
if ENV["deploy_build"] == "true" then
 log "The deploy_build value is true so un-deploying first"
 include_recipe "wt_streaming_barebones::undeploy"
else
 log "The deploy_build value is not set or is false so we will only update the configuration"
end
 
log_dir      = File.join(node['wt_common']['log_dir_linux'], "streamingbarebones")
install_dir  = File.join(node['wt_common']['install_dir_linux'], "streamingbarebones")
 
java_home    = node['java']['java_home']
download_url = node['wt_streaming_barebones']['download_url']
tarball      = node['wt_streaming_barebones']['download_url'].split("/")[-1]
user         = node['wt_streaming_barebones']['user']
group        = node['wt_streaming_barebones']['group']
java_opts    = node['wt_streaming_barebones']['java_opts']
 
# grab the users and passwords from the data bag
auth_data = data_bag_item('authorization', node.chef_environment)
client_token = auth_data['wt_streaming_barebones']['client_token']
client_secret = auth_data['wt_streaming_barebones']['client_secret']
 
log "Install dir: #{install_dir}"
log "Log dir: #{log_dir}"
log "Java home: #{java_home}"
 
# create the log directory
directory log_dir do
 owner   user
 group   group
 mode    00755
 recursive true
 action :create
end
 
# create the bin directory
directory "#{install_dir}/bin" do
 owner "root"
 group "root"
 mode 00755
 recursive true
 action :create
end
 
# create the conf directory
directory "#{install_dir}/conf" do
 owner "root"
 group "root"
 mode 00755
 recursive true
 action :create
end
 
if ENV["deploy_build"] == "true" then
 log "The deploy_build value is true so we will grab the tar ball and install"
 
 # download the application tarball
 remote_file "#{Chef::Config[:file_cache_path]}/#{tarball}" do
   source download_url
   mode 00644
 end
 
 # uncompress the application tarball into the install directory
 execute "tar" do
   user  "root"
   group "root"
   cwd install_dir
   command "tar zxf #{Chef::Config[:file_cache_path]}/#{tarball}"
 end
 
 # delete the application tarball
 execute "delete_install_source" do
   user "root"
   group "root"
   command "rm -f #{Chef::Config[:file_cache_path]}/#{tarball}"
   action :run
 end
 
 # create a runit service
 runit_service "streamingbarebones" do
   options({
     :log_dir => log_dir,
     :install_dir => install_dir,
     :java_home => java_home,
     :user => user
   })
 end
 
end
 
log "Updating the template files"
 
template "#{install_dir}/bin/service-control" do
 source  "service-control.erb"
 owner "root"
 group "root"
 mode  00755
 variables({
   :log_dir => log_dir,
   :install_dir => install_dir,
   :java_home => java_home,
   :java_opts => java_opts
 })
end
 
template "#{install_dir}/conf/log4j.xml" do
 source "log4j.xml.erb"
 owner "webtrends"
 group "webtrends"
 mode 00640
 variables({
   :log_dir => log_dir
 })
end
 
template "#{install_dir}/conf/config.properties" do
 source "config.properties.erb"
 owner "webtrends"
 group "webtrends"
 mode  00640
 variables({
   :port => node['wt_streaming_barebones']['port'],
   :jwt_audience => node['wt_streaming_barebones']['auth_jwt_audience'],
   :jwt_scope => node['wt_streaming_barebones']['auth_jwt_scope'],
   :cam_url => node['wt_cam']['cam_service_url'],
   :auth_url => node['wt_sauth']['auth_service_url'],
   :client_token => client_token,
   :client_secret => client_secret
 })
end
