#
# Cookbook Name:: geminabox
# Recipe:: default
#
# Copyright 2013, Webtrends Inc.
#

gem_package "geminabox"
include_recipe "unicorn"

config_file = "#{node['geminabox']['install_dir']}/config.ru"

template config_file do
  source "config.ru.erb"
  owner "root"
  group "root"
  mode 00644
  variables (
    :install_dir => install_dir
  )
end

unicorn_config config_file do
  listen({ node[:unicorn][:port] => node[:unicorn][:options] })
  working_directory "#{node['geminabox']['install_dir']}/current"
end