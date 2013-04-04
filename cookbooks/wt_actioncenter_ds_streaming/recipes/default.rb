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

install_dir = File.join(node['wt_common']['install_dir_linux'],
"harness/plugins/actioncenter_ds_streaming")
conf_dir = File.join(install_dir, "conf")
tarball      = node['wt_actioncenter_ds_streaming']['download_url'].split("/")[-1]
download_url = node['wt_actioncenter_ds_streaming']['download_url']
user = node['wt_actioncenter_ds_streaming']['user']
group = node['wt_actioncenter_ds_streaming']['group']

sapi_host = node['wt_actioncenter_ds_streaming']['sapi_host']
client_id = node['wt_actioncenter_ds_streaming']['client_id']
client_secret = node['wt_actioncenter_ds_streaming']['client_secret']
auth_url = node['wt_actioncenter_ds_streaming']['auth_url']
auth_user_id =  node['wt_actioncenter_ds_streaming']['auth_user_id']
config_host = node['wt_actioncenter_ds_streaming']['config_host']
config_port = node['wt_actioncenter_ds_streaming']['config_port']

log "Install dir: #{install_dir}"

# create the install directory
directory "#{install_dir}" do
  owner "root"
  group "root"
  mode 00755
  recursive true
  action :create
end

directory "#{conf_dir}" do
  owner "root"
  group "root"
  mode 00755
  action :create
end

def processTemplates(conf_dir, sapi_host, client_id, client_secret,
auth_url,auth_user_id, config_host, config_port)
	%w[producer.properties config.properties].each do | template_file|
		template "#{conf_dir}/#{template_file}" do
			source "#{template_file}.erb"
			owner "root"
			group "root"
			mode 00644
			variables({
				:sapi_host => sapi_host,
				:client_id => client_id,
				:client_secret => client_secret,
				:auth_url => auth_url,
				:auth_user_id => auth_user_id,
				:config_host => config_host,
				:config_port => config_port,
			})
		end
	end
end


if ENV["deploy_build"] == "true" then
  log "The deploy_build value is true so we will grab the tar ball and install"

  # download the application tarball
  remote_file "#{Chef::Config[:file_cache_path]}/#{tarball}" do
    source download_url
    mode 00644
  end

  processTemplates(conf_dir,sapi_host,client_id,client_secret,auth_url,auth_user_id,config_host,config_port)

    # uncompress the application tarball into the install dir
    execute "tar" do
        user  "root"
        group "root"
        cwd install_dir
        command "tar zxf #{Chef::Config[:file_cache_path]}/#{tarball}"
    end

  # delete the install tar ball
  execute "delete_install_source" do
    user "root"
    group "root"
    command "rm -f #{Chef::Config[:file_cache_path]}/#{tarball}"
    action :run
  end

else
end

