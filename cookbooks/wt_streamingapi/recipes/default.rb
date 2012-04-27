#
# Cookbook Name:: wt_streamingapi
# Recipe:: default
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
#

# == Recipes
#include_recipe "java"
include_recipe "runit"

# Install java 
execute "install-java" do
    user "root"
    group "root"
    command "sudo add-apt-repository ppa:webupd8team/java;sudo apt-get update;sudo apt-get install oracle-java7-installer"
    action :run
end

log_dir     = File.join("#{node['wt_common']['log_dir_linux']}", "streamingapi")
install_dir = File.join("#{node['wt_common']['install_dir_linux']}", "streamingapi")
tarball     = node[:wt_streamingapi][:tarball]
download_url = node[:wt_streamingapi][:download_url]
java_home   = node[:wt_streamingapi][:java_home]
port = node[:wt_streamingapi][:port]
cam_url = node[:wt_camservice][:url]
user = node[:wt_streamingapi][:user]
group = node[:wt_streamingapi][:group]
graphite_server = node[:graphite][:server]
graphite_port = node[:graphite][:port]

log "Install dir: #{install_dir}"
log "Log dir: #{log_dir}"
log "Java home: #{java_home}"

directory "#{log_dir}" do
    owner   user
    group   group
    mode    "0755"
    recursive true
    action :create
end
 
directory "#{install_dir}/bin" do
   owner "root"
   group "root"
   mode "0755"
   recursive true
   action :create
end

remote_file "/tmp/#{tarball}" do
  source download_url
  mode "0644"
end

execute "tar" do
  user  "root"
  group "root" 
  cwd install_dir
  command "tar zxf /tmp/#{tarball}"
end

#templates
%w[streamingapi.sh].each do | template_file|
template "#{install_dir}/bin/#{template_file}" do
    source  "#{template_file}.erb"
    owner "root"
    group "root"
    mode  "0755"
    variables({
        :log_dir => log_dir,
        :install_dir => install_dir,
        :java_home => java_home,
        :user => user
    })
    end
end

%w[streaming.properties netty.properties].each do | template_file|
  template "#{install_dir}/conf/#{template_file}" do
	source	"#{template_file}.erb"
	owner "root"
	group "root"
	mode  "0644"
	variables({
        :cam_url => cam_url,
        :install_dir => install_dir,
        :port => port,
	:graphite_server => graphite_server,
        :graphite_port => graphite_port
    })
	end 
end 

execute "delete_install_source" do
    user "root"
    group "root"
    command "rm -f /tmp/#{tarball}"
    action :run
end

runit_service "streamingapi" do
    options({
        :log_dir => log_dir,
        :install_dir => install_dir,
        :java_home => java_home
      }) 
end