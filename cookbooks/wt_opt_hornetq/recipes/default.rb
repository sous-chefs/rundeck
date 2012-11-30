#
# Cookbook Name:: wt_opt_hornetq
# Recipe:: default
#
# Copyright 2012, Webtrends, Inc.
#
# All rights reserved - Do Not Redistribute
#

log "Deploy build is #{ENV["deploy_build"]}"
if ENV["deploy_build"] == "true" then
  log "The deploy_build value is true so un-deploying first"
#  include_recipe "wt_opt_hornetq::undeploy"
else
  log "The deploy_build value is not set or is false so we will only update the configuration"
end

log_dir      = File.join("#{node['wt_common']['log_dir_linux']}", "hornetq")
install_dir  = File.join("#{node['wt_common']['install_dir_linux']}", "hornetq")
tarball      = node['wt_opt_hornetq']['download_url'].split("/")[-1]

bindaddress = "127.0.0.1"
inet = node['network']['interfaces']['eth0']['addresses'].select { |address, data| data["family"] == "inet" }
if inet.size > 0 then
  bindaddress = inet[0][0]
end

include_recipe "java"

# install libaio1 to support AIO in HornetQ
package "libaio1"

user "jboss" do
  home install_dir
  uid node['wt_opt_hornetq']['jboss_uid']
end

group "jboss" do
  gid node['wt_opt_hornetq']['jboss_gid']
end

# create the install directory
directory install_dir do
  recursive true
  owner "jboss"
  group "jboss"
end

# create the log directory
directory log_dir do
  owner   user
  group   group
  mode    000755
  recursive true
  action :create
end


if ENV["deploy_build"] == "true" then
  log "The deploy_build value is true so we will grab the tar ball and install"

  # download the application tarball
  remote_file "#{Chef::Config[:file_cache_path]}/#{tarball}" do
    source node['wt_opt_hornetq']['download_url']
    mode 00644
  end

  # uncompress the application tarball into the install directory
  execute "tar" do
    user  "root"
    group "root"
    cwd install_dir
    command "tar zxf #{Chef::Config[:file_cache_path]}/#{tarball}"
    action :run
  end

  # create a link from the specific version to a generic current folder
  link "#{install_dir}/current" do
    to "#{install_dir}/#{node['wt_opt_hornetq']['hornetq_version']}"
  end

  # set the proper ownership on the install files
  execute "set-ownership" do
    user "root"
    group "root"
    command "chown -Rf jboss:jboss #{install_dir}"
    action :run
  end

  # delete the application tarball
  cookbook_file "#{Chef::Config[:file_cache_path]}/#{tarball}" do
    user "root"
    group "root"
    action :delete
  end

  runit_service "hornetq" do
    options(:basedir => install_dir)
  end

  # add the config xml
  template "hq-config" do
    path "#{install_dir}/current/config/wop/hornetq-configuration.xml"
    source "hornetq-#{node['wt_opt_hornetq']['type']}/#{node['wt_opt_hornetq']['hornetq_version']}-configuration.xml.erb"
    mode 00644
    owner "jboss"
    group "jboss"
    variables(
      :bindaddress => bindaddress
    )
    notifies :restart, resources(:service => "hornetq")
  end

  # add the run sh
  template "hq-run" do
    path "#{install_dir}/current/bin/run.sh"
    source "run.sh.erb"
    mode 00744
    owner "jboss"
    group "jboss"
    variables(
      :bindaddress => bindaddress
    )
    notifies :restart, resources(:service => "hornetq")
  end

end

#Create collectd plugin for hornetq-pod if the collectd recipe has been applied.
if node.attribute?("collectd")
  template "#{node['collectd']['plugin_conf_dir']}/collectd_hornetq.conf" do
    source "/hornetq-#{node['wt_opt_hornetq']['type']}/collectd_hornetq.conf.erb"
    owner "root"
    group "root"
    mode 00644
    notifies :restart, resources(:service => "collectd")
  end
end