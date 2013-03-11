#
# Cookbook Name:: wt_thumbnailcapture
# Recipe:: default
#
# Copyright 2013, Webtrends
#
# All rights reserved - Do Not Redistribute
#

# include runit so we can create a runit service
include_recipe "runit"

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
user         = node['wt_thumbnailcapture']['user']
group        = node['wt_thumbnailcapture']['group']
java_opts    = node['wt_thumbnailcapture']['java_opts']

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

def getMemcacheBoxes
  log "Fetching memcache hosts for environment"
	memcache = search(:node, "chef_environment:support-staging AND roles:memcached")
	boxes = []
	memcache.each do |b|
		boxes << b[:fqdn]
	end
	boxes = boxes.sort
  return boxes.join(",")  
end

def processTemplates (install_dir, node, user, group, log_dir, java_home, mBoxes)
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
		:java_jmx_port => node['wt_thumbnailcapture']['jmx_port'],
		:java_opts => node['wt_thumbnailcapture']['java_opts']
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
		:port => node['wt_thumbnailcapture']['port'],
		:memcache_boxes => mBoxes
	  })
	end

	#Create collectd plugin for thumbnailcapture JMX objects if collectd has been applied.
	if node.attribute?("collectd")
	  template "#{node['collectd']['plugin_conf_dir']}/collectd_thumbnailcapture.conf" do
		source "collectd_thumbnailcapture.conf.erb"
		owner "root"
		group "root"
		mode 00644
		variables({
		  :jmx_port => node['wt_thumbnailcapture']['jmx_port']
		})
		notifies :restart, resources(:service => "collectd")
	  end
	end
end


if ENV["deploy_build"] == "true" then
  log "The deploy_build value is true so we will grab the jar and install"

  # download the application tarball
  remote_file "#{Chef::Config[:file_cache_path]}/#{tarball}" do
    source download_url
    mode 00644
  end

  # not packaging as tar yet
  if 1 == 0 then
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
  end  # 1==0

  processTemplates(install_dir, node, user, group, log_dir, java_home, getMemcacheBoxes())

  # not running as runit service yet
  # create a runit service
  runit_service "thumbnailcapture" do
    options({
      :log_dir => log_dir,
      :install_dir => install_dir,
      :java_home => java_home,
      :user => user
    })
  end

  # install dependencies
  execute "installdependencies" do
    user  "root"
    group "root"
    cwd install_dir
    command "sudo apt-get install unzip xvfb cutycapt -y"
  end

  #copy screencap.erb to init.d folder
  template "/etc/init.d/screencap" do
    source "screencap.erb"
    owner "root"
    user "root"
    group "root"
    mode  00640
  end

  # init screencap config
  execute "framebuffer_config" do
    user "root"
    group "root"
    cwd install_dir
    command "sudo update-rc.d screencap defaults"
  end

  # set screencap up as startup service
  execute "framebuffer_runasstartup" do
    user "root"
    group "root"
    cwd install_dir
    command "sudo chmod 700 /etc/init.d/screencap"
  end

  # start screencap up
  execute "framebuffer_startservice" do
    user "root"
    group "root"
    cwd install_dir
    command "sudo /etc/init.d/screencap start"
  end

  # assign DISPLAY env
  execute "envassignment" do
    user "root"
    group "root"
    command "export DISPLAY=\":1\""
  end

  # explode our artifacts zip file
  execute "explodeartifacts" do
    user  "root"
    group "root"
    cwd install_dir
    command "sudo unzip #{Chef::Config['file_cache_path']}/#{tarball}"
  end

# before we used runit, this invoked the service using java command and java_opts
#  execute "thumbnailcapture" do
#    user  "root"
#    group "root"
#    cwd install_dir
#    command "java -jar capture-service-1.0-SNAPSHOT-jar-with-dependencies.jar&"
#  end

end

else
    processTemplates(install_dir, node, user, group, log_dir, java_home, getMemcacheBoxes())
end

##if node.attribute?("nagios")
  #Create a nagios nrpe check for the healthcheck page
##  nagios_nrpecheck "wt_healthcheck_page" do
##    command "#{node['nagios']['plugin_dir']}/check_http"
##    parameters "-H #{node['fqdn']} -u /healthcheck -p #{node['wt_thumbnailcapture']['healthcheck_port']} -r \"\\\"all_services\\\":\\s*\\\"ok\\\"\""
##    action :add
##  end
##end

service "thumbnailcapture-start" do
  service_name "thumbnailcapture"
  action :start
end

if ENV['deploy_test'] == 'true' 
  minitest_handler "unit-tests" do
    test_name %w{healthcheck}
  end
end

