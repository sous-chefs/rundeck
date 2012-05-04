#
# Cookbook Name:: wt_streamingcollection
# Recipe:: default
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
#

include_recipe "runit"

log_dir      = File.join("#{node['wt_common']['log_dir_linux']}", "streamingcollection")
install_dir  = File.join("#{node['wt_common']['install_dir_linux']}", "streamingcollection")

port         = node[:wt_streamingcollection][:port]
tarball      = node[:wt_streamingcollection][:tarball]
java_home    = node[:java][:java_home]
download_url = node[:wt_streamingcollection][:download_url]
dcsid_url = node[:wt_configdistrib][:dcsid_url]
user = node[:wt_streamingcollection][:user]
group = node[:wt_streamingcollection][:group]

zk_host      = node['zookeeper']['quorum'][0]
zk_port      = node['zookeeper']['clientPort']

graphite_server = node[:graphite][:server]
graphite_port = node[:graphite][:port]
metric_prefix = node[:graphite][:metric_prefix]

log "Install dir: #{install_dir}"
log "Log dir: #{log_dir}"
log "Java home: #{java_home}"

directory "#{log_dir}" do
  owner   user
  group   group
  mode    00755
  recursive true
  action :create
end

directory "#{install_dir}/bin" do
  owner "root"
  group "root"
  mode 00755
  recursive true
  action :create
end

remote_file "/tmp/#{tarball}" do
  source download_url
  mode 00644
end

execute "tar" do
  user  "root"
  group "root" 
  cwd install_dir
  command "tar zxf /tmp/#{tarball}"
end

template "#{install_dir}/bin/streamingcollection.sh" do
  source  "streamingcollection.sh.erb"
  owner "root"
  group "root"
  mode  "0755"
  variables({
    :log_dir => log_dir,
    :install_dir => install_dir,
    :java_home => java_home,
    :user => user
  })
end

template "#{install_dir}/conf/kafka.properties" do
  source  "kafka.properties.erb"
  owner   "root"
  group   "root"
  mode    00644
  variables({
    :zk_connect => "#{zk_host}:#{zk_port}"
  })
end

%w[monitoring.properties config.properties netty.properties].each do | template_file|
  template "#{install_dir}/conf/#{template_file}" do
	source	"#{template_file}.erb"
	owner "root"
	group "root"
	mode  "0644"
	variables({
        :server_url => dcsid_url,
        :install_dir => install_dir,
        :port => port,
        :graphite_server => graphite_server,
        :graphite_port => graphite_port,
        :metric_prefix => metric_prefix
    })
	end 
end


execute "delete_install_source" do
    user "root"
    group "root"
    command "rm -f /tmp/#{tarball}"
    action :run
end

runit_service "streamingcollection" do
  options({
    :log_dir => log_dir,
    :install_dir => install_dir,
    :java_home => java_home
  })
end