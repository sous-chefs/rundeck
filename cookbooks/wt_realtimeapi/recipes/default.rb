#
# Cookbook Name:: wt_realtimeapi
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
    include_recipe "wt_realtimeapi::undeploy"
else
    log "The deploy_build value is not set or is false so we will only update the configuration"
end

 
log_dir     = File.join("#{node['wt_common']['log_dir_linux']}", "realtimeapi")
install_dir = File.join("#{node['wt_common']['install_dir_linux']}", "realtimeapi")
tarball     = "realtimeapi-bin.tar.gz"
download_url = node['wt_realtimeapi']['download_url']
java_home   = node['java']['java_home']

# This is disabled until we can work out windows node search issues     
#    cam_url = search(:node, "role:wt_cam AND chef_environment:#{node.chef_environment}")
user = node['wt_realtimeapi']['user']
group = node['wt_realtimeapi']['group']
java_opts = node['wt_realtimeapi']['java_opts']

log "Install dir: #{install_dir}"
log "Log dir: #{log_dir}"
log "Java home: #{java_home}"

# create the log dir
directory "#{log_dir}" do
    owner   user
    group   group
    mode    00755
    recursive true
    action :create
end

# create the install dir 
directory "#{install_dir}/bin" do
owner "root"
group "root"
mode 00755
recursive true
action :create
end

def processTemplates (install_dir, node)
    log "Updating the template files"
    zookeeper_quorum = node['hbase']['site']['zookeeper_quorum']
    zookeeper_clientport = node['zookeeper']['client_port']
    port = node['wt_realtimeapi']['port']
    cam_url = node['wt_cam']['cam_server_url']

    %w[monitoring.properties config.properties netty.properties hbase.properties].each do | template_file|
    template "#{install_dir}/conf/#{template_file}" do
        source	"#{template_file}.erb"
        owner "root"
        group "root"
        mode  00644
        variables({
            :cam_url => cam_url,
            :install_dir => install_dir,
            :port => port,
		    		:zookeeper_quorum => zookeeper_quorum,
		    		:zookeeper_clientport => zookeeper_clientport,
            :wt_monitoring => node[:wt_monitoring],
            :pod => node[:wt_realtime_hadoop][:pod],
            :data_center => node[:wt_realtime_hadoop][:datacenter]
        })
        end 
    end 
end

if ENV["deploy_build"] == "true" then 
    log "The deploy_build value is true so we will grab the tar ball and install"

    # grab the source file
    remote_file "#{Chef::Config[:file_cache_path]}/#{tarball}" do
    source download_url
    mode 00644
    end

    # extract the source file
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
            :java_class => "com.webtrends.realtime.server.RealtimeApiDaemon",
            # node['wt_monitoring']['jmx_port']
            :java_jmx_port => 9998,
            :java_opts => java_opts
        })
    end

    processTemplates(install_dir, node)
    
    # delete the source file
    execute "delete_install_source" do
        user "root"
        group "root"
        command "rm -f #{Chef::Config[:file_cache_path]}/#{tarball}"
        action :run
    end

    # create the runit service
    runit_service "realtimeapi" do
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

#Create collectd plugin for realtime api JMX objects if collectd has been applied.
if node.attribute?("collectd")
  template "#{node[:collectd][:plugin_conf_dir]}/collectd_realtimeapi.conf" do
    source "collectd_realtimeapi.conf.erb"
    owner "root"
    group "root"
    mode 00644
    notifies :restart, resources(:service => "collectd")
  end
end

if node.attribute?("nagios")
#Create a nagios nrpe check for the healthcheck page
	nagios_nrpecheck "wt_healthcheck_page" do
		command "#{node['nagios']['plugin_dir']}/check_http"
		parameters "-H #{node[:fqdn]} -u /healthcheck -p 8080 -r \"\\\"all_services\\\": \\\"ok\\\"\""
		action :add
	end
end