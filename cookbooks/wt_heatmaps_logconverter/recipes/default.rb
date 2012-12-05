#
# Cookbook Name:: wt_heatmaps_logconverter
# Recipe:: default
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
#

if ENV["deploy_build"] == "true" then
  log "The deploy_build value is true so un-deploying first"
  include_recipe "wt_heatmaps_logconverter::undeploy"
else
  log "The deploy_build value is not set or is false so we will only update the configuration"
end

log_dir      = File.join(node['wt_common']['log_dir_linux'], "heatmaps_logconverter")
install_dir  = File.join(node['wt_common']['install_dir_linux'], "heatmaps_logconverter")
tarball      = node['wt_heatmaps_logconverter']['download_url'].split("/")[-1]
java_home    = node['java']['java_home']
download_url = node['wt_heatmaps_logconverter']['download_url']
user = node['wt_heatmaps_logconverter']['user']
group = node['wt_heatmaps_logconverter']['group']
java_opts = node['wt_heatmaps_logconverter']['java_opts']

hadoop_datanodes = Array.new
search(:node, "role:hadoop_datanode AND chef_environment:#{node.chef_environment}").each do |n|
  hadoop_datanodes << n[:fqdn]
end
hadoop_datanodes.sort!

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
directory "#{install_dir}" do
  owner "root"
  group "root"
  mode 00755
  recursive true
  action :create
end

# create the config directory
directory "#{install_dir}/conf" do
  owner "root"
  group "root"
  mode 00755
  recursive true
  action :create
end

%w[logconverter.properties log4j.properties datanodes.conf ].each do | template_file|
  template "#{install_dir}/conf/#{template_file}" do
    source  "#{template_file}.erb"
    owner "root"
    group "root"
    mode  00644
    variables({
      :install_dir => install_dir,
      :datanodes => hadoop_datanodes
    })
  end
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

  processTemplates(install_dir, node)

  # delete the application tarball
  execute "delete_install_source" do
    user "root"
    group "root"
    command "rm -f #{Chef::Config[:file_cache_path]}/#{tarball}"
    action :run
  end

  # create the service
  service "hmlc" do
    action :create
  end

end

#Create collectd plugin for JMX
if node.attribute?("collectd")
  template "#{node['collectd']['plugin_conf_dir']}/collectd_heatmapslogconverter.conf" do
    source "collectd_heatmapslogconverter.conf.erb"
    owner "root"
    group "root"
    mode 00644
    notifies :restart, resources(:service => "collectd")
  end
end

if node.attribute?("nagios")
  #Create a nagios nrpe check for the healthcheck page
end
