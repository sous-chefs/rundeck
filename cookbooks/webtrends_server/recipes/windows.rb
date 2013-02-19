#
# Author:: Tim Smith(<tim.smith@webtrends.com>)
# Cookbook Name:: webtrends_server
# Recipe:: windows
#
# Copyright 2012, Webtrends Inc.
#
# All rights reserved - Do Not Redistribute
#

# make sure that this recipe only runs on Windows systems
if not platform?("windows")
  Chef::Log.info("Windows required for the Windows recipe.")
  return
end

# save the node to prevent empty run lists on failures
unless Chef::Config[:solo]
  ruby_block "save node data" do
    block do
      node.save
    end
    action :create
  end
end

# make sure someone didn't set the _default environment
if node.chef_environment == "_default"
  Chef::Log.info("Set a Chef environment. We don't want to use _default")
  exit(true)
end

# Needed to handle reboots
include_recipe "windows::reboot_handler"

windows_reboot 60 do
  reason 'Chef Reboot'
  action :nothing
end

# setup the client.rb file for chef with the correct chef server URL and logging options
if !node[:openstack_instance]
  if node['chef_client']['server_url'].nil?
    Chef::Application.fatal!("Your environment must contain a valid [:chef_client][:server_url] value to run the webtrends_server cookbook")
  end
  include_recipe "chef-client::config"
end

# disable UAC
windows_registry 'HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System' do
  values 'EnableLUA' => 0
  notifies :request, "windows_reboot[60]"
end

# turn off hibernation
execute "powercfg-hibernation" do
  command "powercfg.exe /hibernate off"
  action :run
end

# set high performance power options
execute "powercfg-performance" do
  command "powercfg.exe /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c"
  action :run
end


if node['wt_common']['gem_repo']
  execute "remove rubygems" do
    command "gem source -r http://rubygems.org/"
    only_if "gem source | find /I \"http://rubygems.org\""
  end
  
  execute "gem_repo_add" do
    command "gem source -a #{node['wt_common']['gem_repo']}"
    not_if "gem source | find /I \"#{node['wt_common']['gem_repo']}\""
  end
end

gem_package "zip"
chef_gem "chef-jabber-snitch"