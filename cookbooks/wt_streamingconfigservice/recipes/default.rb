#
# Cookbook Name:: wt_streamingconfigservice
# Recipe:: default
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
#

log "Deploy build is #{ENV["deploy_build"]}"
if ENV["deploy_build"] == "true" then
    log "The deploy_build value is true so un-deploy first"
    include_recipe "wt_streamingconfigservice::undeploy"
else
    log "The deploy_build value is not set or is false so we will only update the configuration"
end


log_dir      = File.join("#{node['wt_common']['log_dir_linux']}", "streamingconfigservice")
install_dir  = File.join("#{node['wt_common']['install_dir_linux']}", "streamingconfigservice")

tarball      = "streaming-configservice-bin.tar.gz"
java_home    = node['java']['java_home']
download_url = node['wt_streamingconfigservice']['download_url']
user = node['wt_streamingconfigservice']['user']
group = node['wt_streamingconfigservice']['group']

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

# create the bin directory
directory "#{install_dir}/bin" do
owner "root"
group "root"
mode 00755
recursive true
action :create
end

# create the conf directory
directory "#{install_dir}/conf" do
owner "root"
group "root"
mode 00755
recursive true
action :create
end

if ENV["deploy_build"] == "true" then
    log "The deploy_build value is true so we will grab the tar ball and install"

    # download the application tarball
    remote_file "#{Chef::Config[:file_cache_path]}/#{tarball}" do
    source download_url
    mode 00644
    end

    # uncompress the application tarball into the install directory
    execute "tar" do
    user  "root"
    group "root"
    cwd install_dir
    command "tar zxf #{Chef::Config[:file_cache_path]}/#{tarball}"
    end

    log "Updating the template file"

    template "#{install_dir}/conf/config.properties" do
        source  "config.properties.erb"
        owner   "root"
        group   "root"
        mode    00644
        variables({
            :port => node['wt_streamingconfigservice']['port'],
            :camConnString => node['wt_streamingconfigservice']['camConnString'],
            :masterConnString => node['wt_streamingconfigservice']['masterConnString'],
            :includeUnmappedAnalyticsIds => node['wt_streamingconfigservice']['includeUnmappedAnalyticsIds']
        })
    end

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
            :java_class => "com.webtrends.streaming.configservice.ConfigServiceDaemon",
            :java_jmx_port => 9999,
            :java_opts => ""
       })
    end

    # delete the application tarball
    execute "delete_install_source" do
        user "root"
        group "root"
        command "rm -f #{Chef::Config[:file_cache_path]}/#{tarball}"
        action :run
    end

    # create a runit service
    runit_service "streamingconfigservice" do
    options({
        :log_dir => log_dir,
        :install_dir => install_dir,
        :java_home => java_home,
        :user => user
    })
    end
end