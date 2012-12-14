#
# Cookbook Name:: wt_edge_server
# Recipe:: default
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
#

if ENV["deploy_build"] == "true" then
  log "The deploy_build value is true so un-deploying first"
  include_recipe "wt_edge_server::undeploy"
else
  log "The deploy_build value is not set or is false so we will only update the configuration"
end

log_dir      = File.join(node['wt_common']['log_dir_linux'], "edge_server")
install_dir  = File.join(node['wt_common']['install_dir_linux'], "edge_server")
tarball      = node['wt_edge_server']['download_url'].split("/")[-1]
java_home    = node['java']['java_home']
download_url = node['wt_edge_server']['download_url']
user = node['wt_edge_server']['user']
group = node['wt_edge_server']['group']
java_opts = node['wt_edge_server']['java_opts']

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

# create the config directory
directory "#{install_dir}/conf" do
  owner "root"
  group "root"
  mode 00755
  recursive true
  action :create
end

def processTemplates (install_dir, node, log_dir)

  log "Updating the template files"

  template "#{install_dir}/conf/http.proxy.properties" do
    source  "http.proxy.properties.erb"
    owner   "root"
    group   "root"
    mode    00644
    variables({
      #TODO: Add support for proxying
    })
  end

  template "#{install_dir}/conf/log4j.xml" do
    source  "log4j.xml.erb"
    owner   "root"
    group   "root"
    mode    00644
    variables({
      :log_dir => log_dir,
      :log_level => node['wt_edge_server']['log_level']
    })
  end

  template "#{install_dir}/conf/monitoring.properties" do
    source  "monitoring.properties.erb"
    owner   "root"
    group   "root"
    mode    00644
    variables({
      :wt_monitoring => node['wt_monitoring'],
      :wt_edge_server => node['wt_edge_server']
    })
  end

  template "#{install_dir}/conf/netty.properties" do
    source  "netty.properties.erb"
    owner   "root"
    group   "root"
    mode    00644
    variables({
      :port => node['wt_edge_server']['port']
    })
  end

  template "#{install_dir}/conf/rcs.config.properties" do
    source  "rcs.config.properties.erb"
    owner   "root"
    group   "root"
    mode    00644
    variables({
      :rules_url => File.join(node["wt_streamingconfigservice"]["config_service_url"], 
      node['wt_edge_server']['config_service_rule_endpoint']),
      :active_configs_url => File.join(node["wt_streamingconfigservice"]["config_service_url"], 
      node['wt_edge_server']['active_configs_endpoint'])
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

  template "#{install_dir}/bin/service-control" do
    source  "service-control.erb"
    owner "root"
    group "root"
    mode  00755
    variables({
      :log_dir => log_dir,
      :install_dir => install_dir,
      :java_home => java_home,
      :java_jmx_port => node['wt_edge_server']['jmx_port'],
      :java_opts => java_opts
    })
  end

  processTemplates(install_dir, node, log_dir)

  # delete the application tarball
  execute "delete_install_source" do
    user "root"
    group "root"
    command "rm -f #{Chef::Config[:file_cache_path]}/#{tarball}"
    action :run
  end

  # create a runit service
  runit_service "edge_server" do
    options({
      :install_dir => install_dir,
      :user => user
    })
  end

else
  processTemplates(install_dir, node, log_dir)
end

if node.attribute?("nagios")
  #Create a nagios nrpe check for the healthcheck page for RCS
  nagios_nrpecheck "wt_healthcheck_page" do
   command "#{node['nagios']['plugin_dir']}/check_http"
   parameters "-H #{node['fqdn']} -u /healthcheck -p 8081 -r \"\\\"name\\\":\\\"RCS\\\",\\\"core_services\\\":true,\\\"all_services\\\":true\\\""
   action :add
  end
  #Create a nagios nrpe check for the log file
  nagios_nrpecheck "wt_garbage_collection_limit_reached" do
   command "#{node['nagios']['plugin_dir']}/check_log"
   parameters "-F /var/log/webtrends/edge-server/edge_server.log -O /tmp/edge_server_old.log -q 'GC overhead limit exceeded'"
   action :add
 end
end
