#
# Cookbook Name:: wt_actioncenter_dd_responsys
# Recipe:: default
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
#

if ENV["deploy_build"] == "true" then
  log "The deploy_build value is true so un-deploying first"
  include_recipe "wt_actioncenter_dd_responsys::undeploy"
else
  log "The deploy_build value is not set or is false so we will only update the configuration"
end

install_dir = File.join(node['wt_common']['install_dir_linux'],
"harness/plugins/actioncenter_dd_responsys")
conf_dir = File.join(install_dir, "conf")
tarball      = node['wt_actioncenter_dd_responsys']['download_url'].split("/")[-1]
download_url = node['wt_actioncenter_dd_responsys']['download_url']
user = node['wt_actioncenter_dd_responsys']['user']
group = node['wt_actioncenter_dd_responsys']['group']

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
  action :create
end

def processTemplates(conf_dir)
	log "Updating template files"

	%w[key.pem ResponsysServerCertificate.cer].each do | template_file|
		template "#{conf_dir}/#{template_file}" do
			source "#{template_file}.erb"
			owner "root"
			group "root"
			mode 00644
			variables({})
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

    # uncompress the application tarball into the install dir
    execute "tar" do
        user  "root"
        group "root"
        cwd install_dir
        command "tar zxf #{Chef::Config[:file_cache_path]}/#{tarball}"
    end


	processTemplates(conf_dir)	


  # delete the install tar ball
  execute "delete_install_source" do
    user "root"
    group "root"
    command "rm -f #{Chef::Config[:file_cache_path]}/#{tarball}"
    action :run
  end

else
end

