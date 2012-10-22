
# Cookbook Name:: wt_logpreproc
# Recipe:: default
# Author:: Jeremy Chartrand
#
# Copyright 2012, Webtrends, Inc
#
# All rights reserved - Do Not Redistribute
#
# This recipe installs the needed components to full setup/configure the Log Preprocessor service
#
if ENV["deploy_build"] == "true" then
  log "The deploy_build value is true so un-deploy first"  
  include_recipe "wt_logpreproc::uninstall"
else
  log "The deploy_build value is not set or is false so we will only update the configuration"
end

# get parameters
download_url = node['wt_logpreproc']['download_url']
master_host = node['wt_masterdb']['master_host']
netacuity_host = node['wt_logpreproc']['netacuity_host']

# destinations
install_dir = File.join(node['wt_common']['install_dir_windows'], node['wt_logpreproc']['install_dir'].gsub(/[\\\/]+/,"\\"))
log_dir = File.join(node['wt_common']['install_dir_windows'], node['wt_logpreproc']['log_dir'].gsub(/[\\\/]+/,"\\"))

# get data bag items 
auth_data = data_bag_item('authorization', node.chef_environment)
svcuser = auth_data['wt_common']['system_user']
svcpass = auth_data['wt_common']['system_pass']

# create the install directory
directory install_dir do
	recursive true
	action :create
end

wt_base_icacls node['wt_common']['install_dir_windows'] do
	action :grant
	user svcuser 
	perm :modify
end

if ENV["deploy_build"] == "true" then

	# unzip the install package
	windows_zipfile install_dir do
		source download_url
		action :unzip	
	end
	
	template "#{install_dir}\\geoclient.ini" do
	  source "wtGeoClient.erb"
	  variables(		
		  :netacuity_host => netacuity_host
	  )
	end

	template "#{install_dir}\\wtliveglue.ini" do
	  source "wtLiveGlue.erb"
	  variables(
		  :master_host => master_host,
                  :log_dir => node['cassandra']['cassandra_meta_column']

	  )
	end

	powershell "install wt_logpreproc" do
		environment({'install_dir' => install_dir, 'service_binary' => node['wt_logpreproc']['logpreproc_binary']})
		code <<-EOH
		$binary_path = $env:install_dir + "\\" + $env:service_binary
	        &$binary_path --install
		EOH
	end

	share_wrs 
end
