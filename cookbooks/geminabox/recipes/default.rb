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
  variables ({
    :install_dir => node['geminabox']['install_dir']
  })
end

execute "start_unicorn" do
  command "unicorn -D -p #{node['geminabox']['port']}"
  cwd node['geminabox']['install_dir']
  not_if "ps aux | 'grep [u]nicorn master -D -p #{node['geminabox']['port']}'"
end