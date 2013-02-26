#
# Cookbook Name:: wt_thumbnailcapture
# Recipe:: default
#
# Copyright 2013, Webtrends
#
# All rights reserved - Do Not Redistribute
#
# TODO: clean out unused entries!

# include runit so we can create a runit service
include_recipe "runit"

# install package for mounting nfs volumes
package "nfs-common"

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

# create the conf directory
directory "#{install_dir}/conf/cache" do
  owner "webtrends"
  group "webtrends"
  mode 00755
  recursive true
  action :create
end

# create the share mount dir
directory node['wt_thumbnailcapture']['share_mount_dir'] do
  action :create
end

# mount the NFS mount and add to /etc/fstab
mount node['wt_thumbnailcapture']['share_mount_dir'] do
  device node['wt_thumbnailcapture']['log_share_mount']
  fstype "nfs"
  options "rw"
  action [:mount, :enable]
end

def getZookeeperPairs(node)

  # get the correct environment for the zookeeper nodes
  zookeeper_port = node['zookeeper']['client_port']
  zookeeper_env = node.chef_environment
  unless node['wt_thumbnailcapture']['zookeeper_env'].nil? || node['wt_thumbnailcapture']['zookeeper_env'].empty?
    zookeeper_env = node['wt_thumbnailcapture']['zookeeper_env']
  end

  # grab the zookeeper nodes that are currently available
  zookeeper_pairs = Array.new
  if not Chef::Config.solo
    search(:node, "role:zookeeper AND chef_environment:#{zookeeper_env}").each do |n|
      zookeeper_pairs << n['fqdn']
    end
  end

  # fall back to attribs if search doesn't come up with any zookeeper roles
  if zookeeper_pairs.count == 0
    node['zookeeper']['quorum'].each do |i|
      zookeeper_pairs << i
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

def processTemplates (install_dir, node, user, group, log_dir)
  log "Updating the templated config files"

  # grab the zookeeper nodes that are currently available
  zookeeper_pairs = getZookeeperPairs(node)

  %w[monitoring.properties producer.properties config.properties log4j.xml].each do |template_file|
    template "#{install_dir}/conf/#{template_file}" do
      source  "#{template_file}.erb"
      owner user
      group group
      mode  00755
      variables({
        :wt_thumbnailcapture => node['wt_thumbnailcapture'],
        :zookeeper_pairs => zookeeper_pairs,
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

    # uncompress the application tarball into the install dir
    execute "tar" do
    user  "root"
    group "root"
    cwd install_dir
    command "tar zxf #{Chef::Config['file_cache_path']}/#{tarball}"
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
            :java_opts => java_opts
        })
    end

    processTemplates(install_dir, node, user, group, log_dir)

    # delete the application tarball
    execute "delete_install_source" do
        user "root"
        group "root"
        command "rm -f #{Chef::Config['file_cache_path']}/#{tarball}"
        action :run
    end

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

#Create collectd plugin for thumbnailcapture JMX objects if collectd has been applied.
if node.attribute?("collectd")
  template "#{node['collectd']['plugin_conf_dir']}/collectd_thumbnailcapture.conf" do
    source "collectd_thumbnailcapture.conf.erb"
    owner "root"
    group "root"
    mode 00644
    notifies :restart, resources(:service => "collectd")
  end
end

  #Create a nagios nrpe check for the healthcheck page
###  nagios_nrpecheck "wt_healthcheck_page" do
###    command "#{node['nagios']['plugin_dir']}/check_http"
###    parameters "-H #{node['fqdn']} -u /healthcheck -p 9000 -r \"\\\"all_services\\\":\\s*\\\"ok\\\"\""
###    action :add
###  end
  #Create a nagios nrpe check for the log file
###  nagios_nrpecheck "wt_garbage_collection_limit_reached" do
###    command "#{node['nagios']['plugin_dir']}/check_log"
###    parameters "-F /var/log/webtrends/thumbnailcapture/logreplayer.log -O /tmp/thumbnailcapture_old.log -q 'GC overhead limit exceeded'"
###    action :add
###  end
end