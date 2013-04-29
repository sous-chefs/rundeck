#
# Cookbook Name:: wt_actioncenter_management_api
# Recipe:: default
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
#


auth_data = data_bag_item('authorization',node.chef_environment)
install_dir  = File.join(node['wt_portfolio_harness']['plugin_dir'], "actioncenter_management_api")
conf_dir     = File.join(install_dir,"conf")
tarball      = node['wt_actioncenter_management_api']['download_url'].split("/")[-1]
download_url = node['wt_actioncenter_management_api']['download_url']
user         = node['wt_actioncenter_management_api']['user']
group        = node['wt_actioncenter_management_api']['group']
ads_host     = URI(node['wt_streamingconfigservice']['config_service_url']).host
ads_ssl_port = node['wt_streamingconfigservice']['config_service_ssl_port']
authToken    = auth_data['wt_streamingconfigservice']['authToken']

log "Install dir: #{install_dir}"

if ENV["deploy_build"] == "true" then
  directory install_dir do
    action :delete
    recursive true
    notifies :run, "execute[delete_install_source]"
  end
end

# create the directories
[install_dir, conf_dir].each do |dir|
  directory dir do
    owner "root"
    group "root"
    mode 00755
    recursive true
    action :create
  end
end


# delete the install tar ball
execute "delete_install_source" do
  user "root"
  group "root"
  command "rm -f #{Chef::Config[:file_cache_path]}/#{tarball}"
  action :nothing
end
  
# download the application tarball
remote_file "#{Chef::Config[:file_cache_path]}/#{tarball}" do
  source download_url
  mode 00644
  action :create_if_missing
end

# uncompress the application tarball into the install dir
execute "tar" do
  user  "root"
  group "root"
  cwd install_dir
  command "tar zxf #{Chef::Config[:file_cache_path]}/#{tarball}"
  action :nothing
  creates "#{install_dir}/lib"
  notifies :restart, "service[harness]", :delayed
end 

	#copy messages jar to harness
	#until we solve the class loader issues.
execute "copy messages" do
  command "cp #{install_dir}/lib/action-center-messages*.jar #{node['wt_portfolio_harness']['lib_dir']}/."
  action :nothing
  subscribes :run, resources(:execute => "tar"), :immediately
end


#copy messages jar to harness
#until we solve the class loader issues.
execute "copy messages" do
  command "cp #{install_dir}/lib/action-center-messages*.jar #{node['wt_portfolio_harness']['plugin_dir']}/lib/."
  action :nothing
  subscribes :run, resources(:execute => "tar"), :immediately
end

template "#{conf_dir}/config.properties" do 
  source "config.properties.erb" 
  owner "root" 
  group "root" 
  mode 00644 
  variables({ 
    :ads_host => ads_host,
    :secure_config_host => ads_host,
    :authToken => authToken,
    :secure_config_port => ads_ssl_port,
    :cam_host => node['wt_cam']['cam_service_url'],
    :cam_port => "80",
  })
  notifies :restart, "service[harness]", :delayed
end 
