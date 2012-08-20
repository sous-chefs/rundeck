#
# Cookbook Name:: wt_oauth_redirector
# Recipe:: default
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
#

# Install gems

# Unpack app

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

# Start?

start_cmd = "thin start -C #{install_dir}/oard.thin.yml"
stop_cmd = "thin stop -C #{install_dir}/oard.thin.yml"
