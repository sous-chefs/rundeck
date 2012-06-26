#
# Cookbook Name:: wt_streamingapi
# Recipe:: default
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
#

# include runit so we can create a runit service
include_recipe "runit"

log "Deploy build is #{ENV["deploy_build"]}"
if ENV["deploy_build"] == "true" then 
    log "The deploy_build value is true so un-deploy first"
    include_recipe "wt_streamingapi::undeploy"
else
    log "The deploy_build value is not set or is false so we will only update the configuration"
end


log_dir     = File.join("#{node['wt_common']['log_dir_linux']}", "streamingapi")
install_dir = File.join("#{node['wt_common']['install_dir_linux']}", "streamingapi")
tarball     = "streamingapi-bin.tar.gz"
download_url = node['wt_streamingapi']['download_url']
java_home   = node['java']['java_home']
java_opts = node['wt_streamingapi']['java_opts']
# This is disabled until we can work out windows node search issues     
#    cam_url = search(:node, "role:wt_cam AND chef_environment:#{node.chef_environment}")
user = node['wt_streamingapi']['user']
group = node['wt_streamingapi']['group']

log "Install dir: #{install_dir}"
log "Log dir: #{log_dir}"
log "Java home: #{java_home}"

# create the log directory
directory "#{log_dir}" do
    owner   user
    group   group
    mode    00755
    recursive true
    action :create
end

# create the install directory
directory "#{install_dir}/bin" do
owner "root"
group "root"
mode 00755
recursive true
action :create
end

def processTemplates (install_dir, node)
    log "Updating the template files"
    cam_url = node['wt_cam']['cam_server_url']
    port = node['wt_streamingapi']['port']

    %w[monitoring.properties streaming.properties netty.properties].each do | template_file|
    template "#{install_dir}/conf/#{template_file}" do
        source	"#{template_file}.erb"
        owner "root"
        group "root"
        mode  00644
        variables({
            :cam_url => cam_url,
            :install_dir => install_dir,
            :port => port,
            :wt_monitoring => node[:wt_monitoring]
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

    # uncompress the application tarbarll into the install dir
    execute "tar" do
    user  "root"
    group "root" 
    cwd install_dir
    command "tar zxf #{Chef::Config[:file_cache_path]}/#{tarball}"
    end

    #templates
    template "#{install_dir}/bin/service-control" do
        source  "service-control.erb"
        owner "root"
        group "root"
        mode  00755
        variables({
            :log_dir => log_dir,
            :install_dir => install_dir,
            :java_home => java_home,
            :user => user,
            :java_class => "com.webtrends.streaming.websocket.StreamingAPIDaemon",
            :java_jmx_port => node['wt_monitoring']['jmx_port'],
            :java_opts => java_opts
        })
    end

    processTemplates(install_dir, node)

    # delete the install tar ball
    execute "delete_install_source" do
        user "root"
        group "root"
        command "rm -f #{Chef::Config[:file_cache_path]}/#{tarball}"
        action :run
    end

    # create the runit service
    runit_service "streamingapi" do
        options({
            :log_dir => log_dir,
            :install_dir => install_dir,
            :java_home => java_home,
            :user => user
        }) 
    end
else
    processTemplates(install_dir, node)
end

#Create collectd plugin for streaming api JMX objects if collectd has been applied.
if node.attribute?("collectd")
  template "#{node[:collectd][:plugin_conf_dir]}/collectd_streamingapi.conf" do
    source "collectd_streamingapi.conf.erb"
    owner "root"
    group "root"
    mode 00644
    notifies :restart, resources(:service => "collectd")
  end
end
