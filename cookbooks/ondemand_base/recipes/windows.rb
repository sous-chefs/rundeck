#
# Author:: Tim Smith(<tim.smith@webtrends.com>)
# Cookbook Name:: ondemand_base
# Recipe:: windows
#
# Copyright 2012, Webtrends Inc.
#
# All rights reserved - Do Not Redistribute
#


domain_to_join = node['authorization']['ad_auth']['ad_network']
auth_data = data_bag_item('authorization', domain_to_join)

#Make sure that this recipe only runs on Windows systems
if not platform?("windows")
	Chef::Log.info("Platform Windows required.")
	return
end

include_recipe "windows::reboot_handler"
#Save the node to prevent empty run lists on failures
unless Chef::Config[:solo]
	ruby_block "save node data" do
		block do
			node.save
		end
		action :create
	end
end

#Turn off hibernation
execute "powercfg-hibernation" do
	command "powercfg.exe /hibernate off"
	action :run
end

#Set high performance power options
execute "powercfg-performance" do
	command "powercfg.exe /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c"
	action :run
end

#Install the working version of rubyzip gem
gem_package("rubyzip") do
  options("-v 0.9.5")
end

log "Are you joined to domain? #{node['kernel']['cs_info']['part_of_domain']} Current domain is #{node['kernel']['cs_info']['domain']}"

execute "join domain" do
  command "NETDOM join /Domain:#{domain_to_join} /userD:#{auth_data['auth_domain_user']} /passwordD:#{auth_data['auth_domain_password']} #{node['hostname']}"
  not_if {node['kernel']['cs_info']['part_of_domain']}
  notifies :request, "windows_reboot[60]"
end

windows_registry 'HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System' do
  values 'EnableLUA' => 0
  notifies :request, "windows_reboot[60]"
end

windows_reboot 60 do
  reason 'Chef Reboot'
  action :nothing
end
