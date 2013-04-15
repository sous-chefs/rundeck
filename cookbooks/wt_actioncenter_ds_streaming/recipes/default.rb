#
# Cookbook Name:: wt_actioncenter_ds_streaming
# Recipe:: default
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
#

if ENV["deploy_build"] == "true" then
  log "The deploy_build value is true so un-deploying first"
  include_recipe "wt_actioncenter_ds_streaming::undeploy"
else
  log "The deploy_build value is not set or is false so we will only update the configuration"
end

install_dir  = File.join(node['wt_portfolio_harness']['plugin_dir'], "actioncenter_ds_streaming")
conf_dir     = File.join(install_dir, "conf")
tarball      = node['wt_actioncenter_ds_streaming']['download_url'].split("/")[-1]
download_url = node['wt_actioncenter_ds_streaming']['download_url']
user         = node['wt_actioncenter_ds_streaming']['user']
group        = node['wt_actioncenter_ds_streaming']['group']

client_id     = node['wt_actioncenter_ds_streaming']['client_id']
client_secret = node['wt_actioncenter_ds_streaming']['client_secret']
auth_url      = "#{node['wt_sauth']['auth_url']}/#{node['wt_portfolio_harness']['sauth_version']}/token"
auth_user_id  = node['wt_actioncenter_ds_streaming']['auth_user_id']
config_host   = URI(node['wt_streamingconfigservice']['config_service_url']).host
sapi_port     = search(:node, "role:wt_streaming_api_server AND chef_environment:#{node.chef_environment}").first['wt_streamingapi']['port']

#Dynamically builds kafka topic unless overridden
unless node['wt_actioncenter_ds_streaming']['kafka_topic']
  kafka_topic = "#{node['wt_realtime_hadoop']['datacenter']}_#{node['wt_realtime_hadoop']['pod']}_ActionRoutes"
else
  kafka_topic = node['wt_actioncenter_ds_streaming']['kafka_topic']
end

# grab the zookeeper nodes that are currently available
zookeeper_search = Array.new
if not Chef::Config.solo
  zookeeper_search = search(:node, "role:zookeeper AND chef_environment:#{node.chef_environment}")
end

log "Install dir: #{install_dir}"
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


if ENV["deploy_build"] == "true" then
  log "The deploy_build value is true so we will grab the tar ball and install"

  # download the application tarball
  remote_file "#{Chef::Config[:file_cache_path]}/#{tarball}" do
    source download_url
    mode 00644
  end

    # uncompress the application tarball into the install dir
    execute "tar" do
        user  "root"
        group "root"
        cwd install_dir
        command "tar zxf #{Chef::Config[:file_cache_path]}/#{tarball}"
        notifies :restart, "runit_service[harness]", :delayed
    end

  # delete the install tar ball
  execute "delete_install_source" do
    user "root"
    group "root"
    command "rm -f #{Chef::Config[:file_cache_path]}/#{tarball}"
    action :run
  end
end

%w[producer.properties config.properties].each do | template_file|
    template "#{conf_dir}/#{template_file}" do
      source "#{template_file}.erb"
      owner "root"
      group "root"
      mode 00644
      variables({
        :client_id => client_id,
        :client_secret => client_secret,
        :auth_url => auth_url,
        :auth_user_id => auth_user_id,
        :config_host => config_host,
        :pod => node['wt_realtime_hadoop']['pod'],
        :datacenter => node['wt_realtime_hadoop']['datacenter'],
        :kafka_topic => kafka_topic,
        :zookeeper_search  => zookeeper_search ,
      })
      notifies :restart, "runit_service[harness]", :delayed
    end
  end
