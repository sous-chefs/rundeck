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

user         = node[:user]
group        = node[:group]
tarball      = node[:tarball]
log_dir      = File.join("#{node['wt_common']['log_dir_linux']}", "streamingapi")
install_dir  = File.join("#{node['wt_common']['install_dir_linux']}", "streamingapi")
download_url = node[:download_url]
java_home = "/usr/lib/jvm/java-7-oracle/jre"

log "Install dir: #{install_dir}"
log "Log dir: #{log_dir}"

directory "#{log_dir}" do
    owner "root"
    group "root"
    mode "0755"
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
%w[log4j.properties].each do | template_file|
  template "#{install_dir}/conf/#{template_file}" do
	source	"#{template_file}.erb"
	owner "root"
    group "root"
    mode  "0755"
    variables({
        :log_dir => log_dir,
		:install_dir => install_dir,
        :java_home => java_home
	})
	end
end 

%w[streamingapi.sh sv-streamingapi-run].each do | template_file|
  template "#{install_dir}/bin/#{template_file}" do
	source	"#{template_file}.erb"
	owner "root"
    group "root"
    mode  "0755"
    variables({
      :log_dir => log_dir,
			:install_dir => install_dir,
      :java_home => java_home
	})
	end
end 

runit_service "streamingapi" do
    action :start
end

#execute "start_service" do
#    user "root"
#    group "root"
#    command "#{install_dir}/bin/streamingapi.sh start"
#    action :run
#end

execute "delete_install_source" do
    user "root"
    group "root"
    command "rm -f /tmp/#{tarball}"
    action :run
end
