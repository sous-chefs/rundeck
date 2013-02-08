#
# Cookbook Name:: wt_streamingmanagementservice
# Recipe:: default
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
#

# include runit so we can create a runit service
include_recipe "runit"

if ENV["deploy_build"] == "true" then
  log "The deploy_build value is true so un-deploying first"
  include_recipe "wt_streamingmanagementservice::undeploy"
else
  log "The deploy_build value is not set or is false so we will only update the configuration"
end

log_dir      = File.join(node['wt_common']['log_dir_linux'], "streamingmanagementservice")
install_dir  = File.join(node['wt_common']['install_dir_linux'], "streamingmanagementservice")

java_home    = node['java']['java_home']
download_url = node['wt_streamingmanagementservice']['download_url']
tarball      = node['wt_streamingmanagementservice']['download_url'].split("/")[-1]
user         = node['wt_streamingmanagementservice']['user']
group        = node['wt_streamingmanagementservice']['group']
java_opts    = node['wt_streamingmanagementservice']['java_opts']

# grab the users and passwords from the data bag
auth_data = data_bag_item('authorization', node.chef_environment)
camdbuser  = auth_data['wt_cam_db']['db_user']
camdbpwd = auth_data['wt_cam_db']['db_pwd']
streamingdbuser  = auth_data['wt_streaming_usage_db']['db_user']
streamingdbpwd = auth_data['wt_streaming_usage_db']['db_pwd']

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

  # delete the application tarball
  execute "delete_install_source" do
    user "root"
    group "root"
    command "rm -f #{Chef::Config[:file_cache_path]}/#{tarball}"
    action :run
  end

  # create a runit service
  runit_service "streamingmanagementservice" do
    options({
      :log_dir => log_dir,
      :install_dir => install_dir,
      :java_home => java_home,
      :user => user
    })
  end

end


log "Updating the template files"

template "#{install_dir}/bin/service-control" do
  source  "service-control.erb"
  owner "root"
  group "root"
  mode  00755
  variables({
    :log_dir => log_dir,
    :install_dir => install_dir,
    :java_home => java_home,
    :java_jmx_port => node['wt_streamingmanagementservice']['jmx_port'],
    :java_opts => java_opts
  })
end

template "#{install_dir}/conf/log4j.xml" do
  source "log4j.xml.erb"
  owner user
  group group
  mode 00640
  variables({
    :log_dir => log_dir
  })
end

template "#{install_dir}/conf/config.properties" do
  source "config.properties.erb"
  owner user
  group group
  mode  00640
  variables({
    :port => node['wt_streamingmanagementservice']['port'],
    :camdbserver => node['wt_cam']['db_server'],
    :camdbname => node['wt_cam']['db_name'],
    :camdbuser => camdbuser,
    :camdbpwd => camdbpwd,
    :wt_monitoring => node['wt_monitoring'],
    :streamingdbserver => node['wt_streaming_usage_db']['db_server'],
    :streamingdbname => node['wt_streaming_usage_db']['db_name'],
    :streamingdbuser => streamingdbuser,
    :streamingdbpwd => streamingdbpwd,
    :healthcheck_port => node['wt_streamingmanagementservice']['healthcheck_port'],
  })
end

#Create collectd plugin for streamingmanagementservice JMX objects if collectd has been applied.
if node.attribute?("collectd")
  template "#{node['collectd']['plugin_conf_dir']}/collectd_streamingmanagementservice.conf" do
    source "collectd_streamingmanagementservice.conf.erb"
    owner "root"
    group "root"
    mode 00644
    variables({
      :jmx_port => node['wt_streamingmanagementservice']['jmx_port']
    })
    notifies :restart, resources(:service => "collectd")
  end
end

if node.attribute?("nagios")

  #Create a nagios nrpe check for the healthcheck page
  nagios_nrpecheck "wt_healthcheck_page" do
    command "#{node['nagios']['plugin_dir']}/check_http"
    parameters "-H #{node['fqdn']} -u /healthcheck -p #{node['wt_streamingmanagementservice']['healthcheck_port']} -r \"\\\"all_services\\\":\\s*\\\"ok\\\"\""
    action :add
  end

end

service "SMS-Start" do
  service_name "streamingmanagementservice"
  action :start
end

if ENV['deploy_test'] == 'true' 
  minitest_handler "unit-tests" do
    test_name %w{healthcheck}
  end
end
