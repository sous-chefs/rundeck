#
# Cookbook Name:: wt_hdfslogdata_producer 
# Recipe:: default
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
#



if ENV["deploy_build"] == "true" then
  log "The deploy_build value is true so un-deploying first"
  include_recipe "wt_hdfslogdata_producer::undeploy"
else
  log "The deploy_build value is not set or is false so we will only update the configuration"
end

"log_dir_linux"

log_dir      = File.join(node['wt_common']['log_dir_linux'], "hdfslogdata_producer")
install_dir  = File.join(node['wt_common']['install_dir_linux'], "hdfslogdata_producer")
tarball      = node['wt_hdfslogdata_producer']['download_url'].split("/")[-1]
java_home    = node['java']['java_home']
download_url = node['wt_hdfslogdata_producer']['download_url']
user = node['wt_hdfslogdata_producer']['user']
group = node['wt_hdfslogdata_producer']['group']
java_opts = node['wt_hdfslogdata_producer']['java_opts']
pod = node['wt_realtime_hadoop']['pod']
datacenter = node['wt_realtime_hadoop']['datacenter']

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

# create the bin directory
directory "#{install_dir}/bin" do
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


#any other config file
%w[device-atlas.json browsers.ini].each do |file|
  cookbook_file "#{install_dir}/conf/#{file}" do
     source "#{file}"
     owner "root"
     group "root"
     mode 00644
  end
end



def getZookeeperPairs(node)
  # get the correct environment for the zookeeper nodes
  zookeeper_port = node['zookeeper']['client_port']

  # grab the zookeeper nodes that are currently available
  zookeeper_pairs = Array.new
  if not Chef::Config.solo
    search(:node, "role:zookeeper AND chef_environment:#{node['wt_common']['common_resource_environment']}").each do |n|

      zookeeper_pairs << n[:fqdn]
    end
  end

  # append the zookeeper client port (defaults to 2181)
  i = 0
  while i < zookeeper_pairs.size do
    zookeeper_pairs[i] = zookeeper_pairs[i].concat(":#{zookeeper_port}")
    i += 1
  end

  return zookeeper_pairs
end

def processTemplates (install_dir, node, datacenter, pod)

  log "Updating the template files"

  # grab the zookeeper nodes that are currently available
  zookeeper_pairs = getZookeeperPairs(node)

  %w[config.properties log4j.properties].each do | template_file|
    template "#{install_dir}/conf/#{template_file}" do
      source	"#{template_file}.erb"
      owner "root"
      group "root"
      mode  00644
      variables({
        :install_dir => install_dir,
        :zookeeper_pairs => zookeeper_pairs
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

  # uncompress the application tarball into the install directory
  execute "tar" do
    user  "root"
    group "root"
    cwd install_dir
    command "tar zxf #{Chef::Config[:file_cache_path]}/#{tarball}"
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
      :java_opts => java_opts,
      :java_jmx_port => node['wt_hdfslogdata_producer']['jmx_port']
    })
  end

  processTemplates(install_dir, node, datacenter, pod)

  # delete the application tarball
  execute "delete_install_source" do
    user "root"
    group "root"
    command "rm -f #{Chef::Config[:file_cache_path]}/#{tarball}"
    action :run
  end

  # create a runit service
  runit_service "hdfslogdata_producer" do
    options({
      :log_dir => log_dir,
      :install_dir => install_dir,
      :java_home => java_home,
      :user => user
    })
  end

else
  processTemplates(install_dir, node, datacenter, pod)
end

