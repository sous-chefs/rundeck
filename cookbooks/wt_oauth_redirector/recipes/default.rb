#
# Cookbook Name:: wt_oauth_redirector
# Recipe:: default
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
#

log_dir     = File.join("#{node['wt_common']['log_dir_linux']}", "oauth_redirector")
install_dir = File.join("#{node['wt_common']['install_dir_linux']}", "oauth_redirector")
tarball      = node['wt_oauth_redirector']['download_url'].split("/")[-1]
download_url = node['wt_oauth_redirector']['download_url']
start_cmd = "thin start -C #{install_dir}/oard.thin.yml"
if ENV["deploy_build"] == "true" then 
	include_recipe "wt_oauth_redirector::uninstall"
end

# Install gems

gem_package "sinatra"
gem_package "thin"

# Unpack app
if ENV["deploy_build"] == "true" then 
    log "The deploy_build value is true so we will grab the tar ball and install"

    # download the application tarball
    remote_file "#{Chef::Config[:file_cache_path]}/#{tarball}" do
    source download_url
    mode 00644
    end

    # uncompress the application tarbarll into the install dir
    execute "tar" do
    user  "root"
    group "root" 
    cwd install_dir
    command "tar zxf #{Chef::Config[:file_cache_path]}/#{tarball}"
    end
end


# Set up config templates

template "#{install_dir}/oard_config.yml" do
	source "oard_config.yml.erb"
	variables(
		:log_dir => node['wt_common']['log_dir_linux']
	)
end

template "#{install_dir}/oard.thin.yml" do
	source "oard.thin.yml.erb"
	variables(
		:log_dir => node['wt_common']['log_dir_linux'],
		:chdir => install_dir
	)
end

execute "start application" do
  command start_cmd
  action :run
  ignore_failure true
end