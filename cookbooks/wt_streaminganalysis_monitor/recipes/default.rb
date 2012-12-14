#
# Cookbook Name:: wt_streaminganalysis_monitor
# Recipe:: default
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
#

# include for the URI object
require 'uri'

# include runit so we can create a runit service
include_recipe "runit"

# grab the zookeeper nodes that are currently available
zookeeper_quorum = Array.new
if not Chef::Config.solo
  search(:node, "role:zookeeper AND chef_environment:#{node.chef_environment}").each do |n|
    zookeeper_quorum << n[:fqdn]
  end
end

if ENV["deploy_build"] == "true" then
  log "The deploy_build value is true so un-deploying first"
  include_recipe "wt_streaminganalysis_monitor::undeploy"
else
  log "The deploy_build value is not set or is false so we will only update the configuration"
end

log_dir     = File.join("#{node['wt_common']['log_dir_linux']}", "streaminganalysis_monitor")
install_dir = File.join("#{node['wt_common']['install_dir_linux']}", "streaminganalysis_monitor")
tarball      = node['wt_streaminganalysis_monitor']['download_url'].split("/")[-1]
download_url = node['wt_streaminganalysis_monitor']['download_url']
java_home   = node['java']['java_home']
java_opts = node['wt_streaminganalysis_monitor']['java_opts']
user = node['wt_streaminganalysis_monitor']['user']
group = node['wt_streaminganalysis_monitor']['group']
nimbus_host = search(:node, "role:storm_nimbus AND role:#{node['wt_streaminganalysis_monitor']['cluster_role']} AND chef_environment:#{node.chef_environment}").first[:fqdn]
thrift_port = search(:node, "role:storm_nimbus AND role:#{node['wt_streaminganalysis_monitor']['cluster_role']} AND chef_environment:#{node.chef_environment}").first[:storm][:nimbus][:thrift_port]

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

# create the install directory
directory "#{install_dir}/bin" do
  owner "root"
  group "root"
  mode 00755
  recursive true
  action :create
end

directory "#{install_dir}/conf" do
  owner "root"
  group "root"
  mode 00755
  recursive true
  action :create
end

def processTemplates (install_dir, log_dir, node, zookeeper_quorum, nimbus_host, thrift_port)
  log "Updating the template files"

  %w[log4j.xml config.properties kafka.properties].each do | template_file|
    template "#{install_dir}/conf/#{template_file}" do
      source    "#{template_file}.erb"
      owner "root"
      group "root"
      mode  00644
      variables({
        :install_dir => install_dir,
        :log_dir => log_dir,
        :wt_streaminganalysis_monitor => node['wt_streaminganalysis_monitor'],
        :wt_monitoring => node['wt_monitoring'],
        :zookeeper_quorum => zookeeper_quorum * ",",
        :nimbus_host => nimbus_host,
        :thrift_port => thrift_port
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
      :java_jmx_port => node['wt_streaminganalysis_monitor']['jmx_port'],
      :java_opts => java_opts
    })
  end

  processTemplates(install_dir, log_dir, node, zookeeper_quorum, nimbus_host, thrift_port)

  # delete the install tar ball
  execute "delete_install_source" do
    user "root"
    group "root"
    command "rm -f #{Chef::Config[:file_cache_path]}/#{tarball}"
    action :run
  end

  # create the runit service
  runit_service "streaminganalysis-monitor" do
    options({
      :log_dir => log_dir,
      :install_dir => install_dir,
      :java_home => java_home,
      :user => user
    })
  end

else
  processTemplates(install_dir, log_dir, node, zookeeper_quorum, nimbus_host, thrift_port)
end

if node.attribute?("nagios")
  #Create a nagios nrpe check for the healthcheck page
  nagios_nrpecheck "wt_healthcheck_page" do
    command "#{node['nagios']['plugin_dir']}/check_http"
    parameters "-H #{node['fqdn']} -u /healthcheck -p #{node['wt_streaminganalysis_monitor']['healthcheck_port']} -r \"\\\"all_services\\\": \\\"ok\\\"\""
    action :add
  end

  # Create a nagios nrpe check for the overall Storm health
  nagios_nrpecheck "wt_storm_healthcheck" do
    command "#{node['nagios']['plugin_dir']}/check_http"
    parameters "-H #{node['fqdn']} -u /healthcheck -p #{node['wt_streaminganalysis_monitor']['healthcheck_port']} -r \"\\\"storm_healthcheck\\\":\\{\\\"healthy\\\": \\\"true\\\"\""
    action :add
  end
end
