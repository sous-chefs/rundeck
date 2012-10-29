#
# Cookbook Name:: wt_opt_ots
# Recipe:: default
#
# Copyright 2012, Webtrends, Inc.
#
# All rights reserved - Do Not Redistribute
#

log "Deploy build is #{ENV["deploy_build"]}"
if ENV["deploy_build"] == "true" then
  log "The deploy_build value is true so un-deploy first"
  include_recipe "wt_streamingcollection::undeploy"
else
  log "The deploy_build value is not set or is false so we will only update the configuration"
end

log_dir      = File.join("#{node['wt_common']['log_dir_linux']}", "ots")
install_dir  = File.join("#{node['wt_common']['install_dir_linux']}", "ots")
tarball      = node['wt_opt_ots']['download_url'].split("/")[-1]

include_recipe "java"
include_recipe "apache2"
include_recipe "apache2::mod_deflate"
include_recipe "apache2::mod_headers"
include_recipe "apache2::mod_proxy"
include_recipe "apache2::mod_proxy_http"
include_recipe "apache2::mod_headers"

# only include the Apache worker recipe if we want mpm=worker
if node['wt_opt_ots']['apache']['mpm'] == "worker" then
  include_recipe "apache2::worker"
end

# only include mod_ssl if the node will have SSL terminated at the host
if node['wt_opt_ots']['ssl']
  include_recipe "apache2::mod_ssl"
end

# rotate logs
package "logrotate"

# Copy in the log rotate config
cookbook_file "/etc/logrotate.d/apache2" do
  source "apache2.logrotate"
  backup false
  owner "root"
  group "root"
  mode 00644
end

# Setup logrotate to run via cron hourly
link "/etc/cron.hourly/logrotate" do
 to "/etc/cron.daily/logrotate"
end

# install aio library
package "libaio1"

# create the jboss user
user "jboss" do
  home "#{node['wt_opt_ots']['install_dir']}"
  uid node['wt_opt_ots']['jboss_gid']
end

# create the jboss group
group "jboss" do
  gid node['wt_opt_ots']['jboss_gid']
end

# create the install dir and www/w3c directory
directory "#{node['wt_opt_ots']['install_dir']}/www/w3c" do
  recursive true
end

# install nfs package so we can mount the file store
package "nfs-common"

# create the mount point
directory "#{node['wt_opt_ots']['mount_dir_prefix']}-#{node.chef_environment}" do
  action :create
end

# mount the file store
mount "#{node['wt_opt_ots']['mount_dir_prefix']}-#{node.chef_environment}" do
  device "#{node['wt_opt_ots']['nfs_mount']}"
  fstype nfs
  action [ :mount, :enable ]
  options "rw,hard,intr"
  dump 0
  pass 0
  only_if do File.directory?("#{node['wt_opt_ots']['mount_dir_prefix']}-#{node.chef_environment}") end
end

# disable the default Apache site
apache_site "000-default" do
  enable false
  notifies :reload, resources(:service => "apache2")
end

apache_site "default" do
  enable false
  notifies :reload, resources(:service => "apache2")
end

apache_site "default-ssl" do
  enable false
  notifies :reload, resources(:service => "apache2")
end

# perform actions that need to be gated by a deploy flag
if ENV["deploy_build"] == "true" then
  log "The deploy_build value is true so we will grab the tar ball and install"

  cookbook_file "#{node['wt_opt_ots']['install_dir']}/w3c/p3p.xml" do
    source "p3p.xml"
    owner "root"
    group "root"
    mode 00644
  end

  # Add the crossdomain.xml file needed by flash
  cookbook_file "#{node['wt_opt_ots']['install_dir']}/crossdomain.xml" do
    source "ots/crossdomain.xml"
    owner "root"
    group "root"
    mode 00644
  end

  if node['wt_opt_ots']['ssl']
    ssl_certificate "#{node['wt_opt_ots']['frontend_url']}" do
      notifies :reload, resources(:service => "apache2")
    end
  end

  # load up the apache conf
  template "apache-ots-config" do
    path "#{node['apache']['dir']}/sites-available/ots.conf"
    source "ots.conf.erb"
    mode 00644
    owner "root"
    group "root"
    notifies :reload, resources(:service => "apache2")
  end

  # enable
  apache_site "ots.conf" do
    notifies :reload, resources(:service => "apache2")
  end

  runit_service "wop" do
    run_restart false
    options(
      :basedir => node['wt_opt_ots']['install_dir'],
      :javaopts => node['wt_opt_ots']['javaopts']
    )
  end

  # enable in service load balancer check
  file "#{node['wt_opt_ots']['install_dir']}/lbpool-inservice.txt"

end


