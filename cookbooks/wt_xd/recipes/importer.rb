#
# Cookbook Name:: wt_xd
# Recipe:: default
#
# Copyright 2012, Webtrends Inc.
#
# All rights reserved - Do Not Redistribute
#

if ENV["deploy_build"] == "true" then
  log "The deploy_build value is true so un-deploy first"  
  include_recipe "wt_xd::importer_uninstall"
else
  log "The deploy_build value is not set or is false so we will only update the configuration"
end

download_url = node['wt_xd']['importer']['download_url']

# destinations
install_dir = File.join(node['wt_common']['install_dir_windows'], node['wt_xd']['importer']['install_dir']).gsub(/[\\\/]+/,"\\")
log_dir = File.join(node['wt_common']['install_dir_windows'], "logs")

# get data bag items
auth_data = data_bag_item('authorization', node.chef_environment)
svcuser = auth_data['wt_common']['system_user']
svcpass = auth_data['wt_common']['system_pass']

googleplay_key = data_bag_item('rsa_keys', 'googleplay')

# create the install directory
directory install_dir do
  recursive true
  action :create
end

directory log_dir do
  recursive true
  action :create
end

wt_base_icacls install_dir do
    user svcuser
    perm :modify
    action :grant
end

wt_base_icacls log_dir do
    user svcuser
    perm :modify
    action :grant
end

if ENV["deploy_build"] == "true"

	# unzip the install package
	windows_zipfile install_dir do
		source download_url
		action :unzip
	end

  template "#{install_dir}\\PublicPrivateKeys.rsa" do
    source "PublicPrivateKeys.rsa.erb"
    variables(
      :modulus => googleplay_key['modulus'],
      :exponent => googleplay_key['exponent'],
      :p => googleplay_key['p'],
      :q => googleplay_key['q'],
      :dp => googleplay_key['dp'],
      :dq => googleplay_key['dq'],
      :inverse_q => googleplay_key['inverse_q'],
      :d => googleplay_key['d']
    )
  end
	
    %w[Webtrends.ActionCenterControl.exe.config Webtrends.ExternalData.Refresh.exe.config Webtrends.ExternalData.RetrievalService.exe.config
    	Webtrends.ExternalData.StorageService.exe.config
    	Webtrends.ExternalData.StorageService.log4net.config].each do |template_file|
	  template "#{install_dir}\\#{template_file}" do
	  source "#{template_file}.erb"
	  variables({
	  	  :log_dir => log_dir,
		  :master_host => node['wt_masterdb']['host'],
		  :cass_host => node['cassandra']['cassandra_host'],
		  :report_column => node['cassandra']['cassandra_report_column'],
		  :thrift_port => node['cassandra']['cassandra_thrift_port'],
		  :metadata_column => node['cassandra']['cassandra_meta_column'],
		  :admin_email => node['wt_common']['admin_email'],
		  :support_email => node['wt_common']['tech_support_email'],
		  :target_email => node['wt_actioncenter']['exact_target_email'],
		  :bcc_email => node['wt_actioncenter']['bcc_email']
		  :hbase_location => node['hbase']['location']
		  :hbase_data_center_id => node['hbase']['data_center_id']
		  :hbase_pod_id => node['hbase']['pod_id']
		  :hbase_thrift_port => node['hbase']['thrift_port']
	  })
	  end
    end

# run iss command on the .rsa file  

  wt_base_icacls "C:\\ProgramData\\Microsoft\\Crypto\\RSA\\MachineKeys" do
    user node['current_user']
    perm :modify
    action :grant
  end

  node['wt_xd']['importer']['plugins'].each do |plugin|

    execute "asp_regiis_pi" do   
      command  "C:\\Windows\\Microsoft.NET\\Framework64\\v4.0.30319\\aspnet_regiis -pi #{plugin} #{install_dir}\\PublicPrivateKeys.rsa"
    end

    execute "asp_regiis_pa" do
      command  "C:\\Windows\\Microsoft.NET\\Framework64\\v4.0.30319\\aspnet_regiis -pa #{plugin} #{svcuser}"
    end
  end

  # delete the .rsa file
  file "#{install_dir}\\bin\\PublicPrivateKeys.rsa" do
    action :delete
  end

  wt_base_icacls "C:\\ProgramData\\Microsoft\\Crypto\\RSA\\MachineKeys" do
    user node['current_user']
    perm :modify
    action :remove
  end

  # Creates the services and issues initial startup commands
  xd_rs = File.join(install_dir, node['wt_xd']['retrieval']['service_binary']).gsub(/[\\\/]+/,"\\")
  execute xd_rs do
    command "#{xd_rs} --install --SERVICEACCOUNT=#{svcuser} --SERVICEPASS=#{svcpass}"
  end

  xd_ss = File.join(install_dir, node['wt_xd']['storage']['service_binary']).gsub(/[\\\/]+/,"\\")
  execute xd_ss do
    command "#{xd_ss} --install --SERVICEACCOUNT=#{svcuser} --SERVICEPASS=#{svcpass}"
  end  

  share_wrs
end

service "Start #{node['wt_xd']['retrieval']['service_name']}" do
	action :start
end

service "Start #{node['wt_xd']['storage']['service_name']}" do
	action :start
end

