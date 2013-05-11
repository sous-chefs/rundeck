#
# Cookbook Name:: wt_log_producer
# Recipe:: default
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
#


install_dir  = File.join(node['wt_portfolio_harness']['plugin_dir'], "log_producer")
conf_dir     = File.join(install_dir,"conf")
cache_dir    = File.join(conf_dir, "cache")
tarball      = node['wt_log_producer']['download_url'].split("/")[-1]
download_url = node['wt_log_producer']['download_url']
topic        = node['wt_log_producer']['topic']
conf_host    = URI(node['wt_streamingconfigservice']['config_service_url'])

log "Install dir: #{install_dir}"

# delete the install tarball
if ENV["deploy_build"] == "true" then
  execute "delete_cache" do
    user "root"
    group "root"
    command "rm -f #{Chef::Config[:file_cache_path]}/#{tarball}"
    action :run
  end
end


# download the application tarball
remote_file "#{Chef::Config[:file_cache_path]}/#{tarball}" do
  source download_url
  mode 00644
  action :create_if_missing
  notifies :delete, "directory[#{install_dir}]", :immediately
end

# create the directories
[install_dir, conf_dir, cache_dir].each do |dir|
  directory dir do
    owner "root"
    group "root"
    mode 00755
    recursive true
    action :create
  end
end

# uncompress the application tarball into the install dir
execute "untar" do
  user  "root"
  group "root"
  cwd install_dir
  command "tar zxf #{Chef::Config[:file_cache_path]}/#{tarball}"
  creates "#{install_dir}/lib"
  notifies :restart, "service[harness]", :delayed
end 

# apply the configuration template
template "#{conf_dir}/log-producer.conf" do 
  source "log-producer.conf.erb" 
  owner "root" 
  group "root" 
  mode 00644 
  variables({ 
    :topic => topic,
    :sdcDir => node['wt_log_producer']['sdc_dir'],
    :hclfDir => node['wt_log_producer']['hclf_dir'],
    :whitelistUrl => "#{conf_host}/whitelist/logproducer",
    :whitelistUrlCacheDir => cache_dir,
  })
  notifies :restart, "service[harness]", :delayed
end 
