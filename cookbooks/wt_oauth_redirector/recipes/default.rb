#
# Cookbook Name:: wt_oauth_redirector
# Recipe:: default
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
#

log_dir     = File.join(node['wt_common']['log_dir_linux'], "oauth_redirector")
install_dir = File.join(node['wt_common']['install_dir_linux'], "oauth_redirector")
tarball      = node['wt_oauth_redirector']['download_url'].split("/")[-1]
download_url = node['wt_oauth_redirector']['download_url']
start_cmd = "thin start -C #{install_dir}/oard.thin.yml"
if ENV["deploy_build"] == "true" then
	include_recipe "wt_oauth_redirector::uninstall"
end

directory install_dir do
  action :create
  recursive true
end

directory log_dir do
  action :create
  recursive true
end

# Install gems
package "ruby-dev"
gem_package "sinatra"
gem_package "thin"

# Set up config templates

template "#{install_dir}/oard_config.yml" do
	source "oard_config.yml.erb"
	variables(
		:log_dir => node['wt_common']['log_dir_linux'],
		:log_name => node['wt_oauth_redirector']['logname']
	)
end

template "#{install_dir}/oard.thin.yml" do
	source "oard.thin.yml.erb"
	variables(
		:log_dir 	=> node['wt_common']['log_dir_linux'],
		:chdir 		=> install_dir,
		:log_name 	=> node['wt_oauth_redirector']['logname'],
		:ipaddress 	=> node['ipaddress'],
		:oauth_port		=> node['wt_oauth_redirector']['port']
	)
end

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

	runit_service "oauth_redirector" do
	  run_restart false
	  options(
			:install_dir => install_dir
		)
	  notifies :restart, "service[oauth_redirector]"
	end
end

service "oauth_redirector" do
  action :start
  ignore_failure true
end

if node.attribute?("nagios")
  #Create a nagios nrpe check for the the IP address of the node page
	nagios_nrpecheck "wt_oauth_redirector_health" do
		command "#{node['nagios']['plugin_dir']}/check_http"
		parameters "-H #{node['fqdn']} -p 8080"
		action :add
	end
end