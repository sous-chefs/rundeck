#
# Author:: Tim Smith(<tim.smith@webtrends.com>)
# Cookbook Name:: ondemand_base
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

include_recipe "windows::reboot_handler" #Needed to handle reboots

windows_reboot 60 do
	reason 'Chef Reboot'
	action :nothing
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

# copy a deploy file that can be called to execuate a deploy via rundeck
cookbook_file "#{node['chef_client']['conf_dir']}\\deploy.bat" do
	source "deploy.bat"
end

