#
# Cookbook Name:: wt_realtimeapi
# Recipe:: default
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
#

# include runit so we can create a runit service
include_recipe "runit"

log_dir     = File.join("#{node['wt_common']['log_dir_linux']}", "realtimeapi")
install_dir = File.join("#{node['wt_common']['install_dir_linux']}", "realtimeapi")
tarball     = node['wt_realtimeapi']['tarball']
download_url = node['wt_realtimeapi']['download_url']
java_home   = node['java']['java_home']
port = node['wt_realtimeapi']['port']
cam_url = node['wt_camservice']['url']
user = node['wt_realtimeapi']['user']
group = node['wt_realtimeapi']['group']
graphite_server = node['graphite']['server']
graphite_port = node['graphite']['port']

log "Install dir: #{install_dir}"
log "Log dir: #{log_dir}"
log "Java home: #{java_home}"

# create the log dir
directory "#{log_dir}" do
    owner   user
    group   group
    mode    00755
    recursive true
    action :create
end

# create the install dir 
directory "#{install_dir}/bin" do
   owner "root"
   group "root"
   mode 00755
   recursive true
   action :create
end

# grab the source file
remote_file "#{Chef::Config[:file_cache_path]}/#{tarball}" do
  source download_url
  mode 00644
end

# extract the source file
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
        :user => user,
        :java_class => "com.webtrends.realtime.server.RealtimeApiDaemon",
        :java_jmx_port => 9998
    })
end


%w[config.properties netty.properties].each do | template_file|
  template "#{install_dir}/conf/#{template_file}" do
	source	"#{template_file}.erb"
	owner "root"
	group "root"
	mode  00644
	variables({
        :cam_url => cam_url,
        :install_dir => install_dir,
        :port => port,
	:graphite_server => graphite_server,
        :graphite_port => graphite_port
    })
	end 
end 

# delete the source file
execute "delete_install_source" do
    user "root"
    group "root"
    command "rm -f #{Chef::Config[:file_cache_path]}/#{tarball}"
    action :run
end

# create the runit service
runit_service "realtimeapi" do
    options({
        :log_dir => log_dir,
        :install_dir => install_dir,
        :java_home => java_home,
        :user => user
      }) 
end
