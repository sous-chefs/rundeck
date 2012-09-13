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
  mode 0644
end

# Setup logrotate to run via cron
link "/etc/cron.hourly/logrotate" do
 to "/etc/cron.daily/logrotate"
end

# install aio library
package "libaio1"

# create the jboss user and group
user "jboss" do
  home "#{node['wt_opt_ots']['install_dir']}"
  uid node['wt_opt_ots']['jboss_gid']
end

group "jboss" do
  gid node['wt_opt_ots']['jboss_gid']
end

# gather information about what server we're hitting
cookbook_file "/var/www/debug.php" do
  source "debug.php"
  owner "root"
  group "root"
  mode 00644
end

# delete the default web page that ships with Apache2
file "/var/www/index.html" do
  action :delete
end

# perform actions that need to be gated by a deploy flag
if ENV["deploy_build"] == "true" then
  log "The deploy_build value is true so we will grab the tar ball and install"


# enable in service load balancer check
file "/var/www/lbpool-inservice.txt"

end



