#
# Cookbook Name:: wt_streamingaudit
# Recipe:: default
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
#

# include runit so we can create a runit service
include_recipe "runit"

log "Deploy build is #{ENV["deploy_build"]}"
if ENV["deploy_build"] == "true" then 
    log "The deploy_build value is true so un-deploy first"
    include_recipe "wt_streamingaudit::undeploy"
else
    log "The deploy_build value is not set or is false so we will only update the configuration"
end

log_dir      = File.join("#{node['wt_common']['log_dir_linux']}", "streamingaudit")
install_dir  = File.join("#{node['wt_common']['install_dir_linux']}", "streamingaudit")

tarball      = "streamingaudit-bin.tar.gz"
java_home    = node['java']['java_home']
download_url = node['wt_streamingaudit']['download_url']
user = node['wt_streamingaudit']['user']
group = node['wt_streamingaudit']['group']
java_opts = node['wt_streamingaudit']['java_opts']

log "Install dir: #{install_dir}"
log "Log dir: #{log_dir}"
log "Java home: #{java_home}"

# create the log directory
directory "#{log_dir}" do
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

def getZookeeperPairs(node)
		# get the correct environment for the zookeeper nodes
	  zookeeper_port = node['zookeeper']['client_port']
	  
	  # grab the zookeeper nodes that are currently available
	  zookeeper_pairs = Array.new
	  if not Chef::Config.solo
	      search(:node, "role:zookeeper AND chef_environment:#{node.chef_environment}").each do |n|
	          zookeeper_pairs << n[:fqdn]
	      end
	  end
	
	# fall back to attribs if search doesn't come up with any zookeeper roles
	if zookeeper_pairs.count == 0
		node[:zookeeper][:quorum].each do |i|
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

def processTemplates (install_dir, node)
    log "Updating the template files"
    listener_threads = node['wt_streamingaudit']['listener_threads']

    # grab the zookeeper nodes that are currently available
    zookeeper_pairs = getZookeeperPairs(node)

    template "#{install_dir}/conf/kafka.properties" do
    source  "kafka.properties.erb"
    owner   "root"
    group   "root"
    mode    00644
    variables({
        :zookeeper_pairs => zookeeper_pairs
    })
    end

    %w[auditor.properties].each do | template_file|
    template "#{install_dir}/conf/#{template_file}" do
        source	"#{template_file}.erb"
        owner "root"
        group "root"
        mode  00644
        variables({
            :zookeeper_pairs => zookeeper_pairs,
            :wt_streamingaudit => node[:wt_streamingaudit],
            :wt_monitoring => node[:wt_monitoring],
            :pod => node[:wt_realtime_hadoop][:pod],
            :datacenter => node[:wt_realtime_hadoop][:datacenter]
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
            :user => user,
            :java_class => "com.webtrends.streaming.auditor.AuditorDaemon",
            :java_jmx_port => node['wt_monitoring']['jmx_port'],
            :java_opts => java_opts
        })
    end

    processTemplates(install_dir, node)

    # delete the application tarball
    execute "delete_install_source" do
        user "root"
        group "root"
        command "rm -f #{Chef::Config[:file_cache_path]}/#{tarball}"
        action :run
    end

    # create a runit service
    runit_service "streamingaudit" do
    options({
        :log_dir => log_dir,
        :install_dir => install_dir,
        :java_home => java_home,
        :user => user
    })
    end
else
    processTemplates(install_dir, node)
end
