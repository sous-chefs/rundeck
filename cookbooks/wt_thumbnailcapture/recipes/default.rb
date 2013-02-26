#
# Cookbook Name:: wt_thumbnailcapture
# Recipe:: default
#
# Copyright 2013, Webtrends
#
# All rights reserved - Do Not Redistribute
#
# include runit so we can create a runit service
include_recipe "runit"

# if in deploy mode then uninstall the product first
if ENV["deploy_build"] == "true" then
  log "The deploy_build value is true so un-deploying first"
  include_recipe "wt_thumbnailcapture::undeploy"
else
  log "The deploy_build value is not set or is false so we will only update the configuration"
end

log_dir      = File.join(node['wt_common']['log_dir_linux'], "thumbnailcapture")
install_dir  = File.join(node['wt_common']['install_dir_linux'], "thumbnailcapture")

java_home    = node['java']['java_home']
download_url = node['wt_thumbnailcapture']['download_url']
tarball      = node['wt_thumbnailcapture']['download_url'].split("/")[-1]
user = node['wt_thumbnailcapture']['user']
group = node['wt_thumbnailcapture']['group']
java_opts = node['wt_thumbnailcapture']['java_opts']

log "Install dir: #{install_dir}"
log "Log dir: #{log_dir}"
log "Java home: #{java_home}"

# create the log directory
directory log_dir do
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

def processTemplates (install_dir, node, user, group, log_dir)
  log "Updating the templated config files"

  %w[monitoring.properties producer.properties config.properties log4j.xml].each do |template_file|
    template "#{install_dir}/conf/#{template_file}" do
      source  "#{template_file}.erb"
      owner user
      group group
      mode  00755
      variables({
        :wt_thumbnailcapture => node['wt_thumbnailcapture'],
        :wt_monitoring => node['wt_monitoring'],
        :log_dir => log_dir
      })
    end
  end
end


if ENV["deploy_build"] == "true" then
    log "The deploy_build value is true so we will grab the tar ball and install"

    # download the application tarball
    remote_file "#{Chef::Config['file_cache_path']}/#{tarball}" do
    source download_url
    mode 00644
    end

    # invoke the service using java command and java_opts
###    execute "java" do
###    user  "root"
###    group "root"
###    cwd install_dir
###    command "java -jar #{Chef::Config['file_cache_path']}/#{tarball}"
###    end

    processTemplates(install_dir, node, user, group, log_dir)

    # delete the application tarball
###    execute "delete_install_source" do
###        user "root"
###        group "root"
###        command "rm -f #{Chef::Config['file_cache_path']}/#{tarball}"
###        action :run
###    end

    # create a runit service
    runit_service "thumbnailcapture" do
    options({
        :log_dir => log_dir,
        :install_dir => install_dir,
        :java_home => java_home,
        :user => user
    })
    end
else
    processTemplates(install_dir, node, user, group, log_dir)
end

