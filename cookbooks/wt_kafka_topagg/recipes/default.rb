#
# Cookbook Name:: wt_kafka_topagg
# Recipe:: default
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
#

if ENV["deploy_build"] == "true" then
  log "The deploy_build value is true so un-deploying first"
  include_recipe "wt_kafka_topagg::undeploy"
else
  log "The deploy_build value is not set or is false so we will only update the configuration"
end

name  = node['wt_kafka_topagg']['name']

log_dir      = File.join(node['wt_common']['log_dir_linux'], name)
install_dir  = File.join(node['wt_common']['install_dir_linux'], name)

tarball      = node['wt_kafka_topagg']['download_url'].split("/")[-1]
download_url = node['wt_kafka_topagg']['download_url']

java_home    = node['java']['java_home']
java_opts = node['wt_kafka_topagg']['java_opts']

user = node['wt_kafka_topagg']['user']
group = node['wt_kafka_topagg']['group']

pod = node['wt_realtime_hadoop']['pod']
datacenter = node['wt_realtime_hadoop']['datacenter']

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
directory "#{install_dir}" do
    owner "root"
    group "root"
    mode 00755
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

# create the config directory
directory "#{install_dir}/conf" do
    owner "root"
    group "root"
    mode 00755
    recursive true
    action :create
end

# get the correct environment for the zookeeper nodes
zookeeper_port = node['zookeeper']['client_port']

# grab the zookeeper nodes that are currently available
zookeeper_pairs = Array.new
if not Chef::Config.solo
    search(:node, "role:zookeeper AND chef_environment:#{node.chef_environment}").each do |n|
        zookeeper_pairs << n[:fqdn]
    end
end

# append the zookeeper client port (defaults to 2181)
i = 0
while i < zookeeper_pairs.size do
    zookeeper_pairs[i] = zookeeper_pairs[i].concat(":#{zookeeper_port}")
    i += 1
end

template "#{install_dir}/conf/monitoring.properties" do
    source "monitoring.properties.erb"
    owner "root"
    group "root"
    mode  00644
    variables({
        :zookeeper_pairs => zookeeper_pairs
    })
end

template "#{install_dir}/conf/log4j.xml" do
    source "log4j.xml.erb"
    owner "root"
    group "root"
    mode  00644
    variables({
        :log_dir => log_dir,
        :log_prefix => name
    })
end

template "#{install_dir}/conf/config.json" do
    source "config.json.erb"
    owner "root"
    group "root"
    mode  00644
    variables({
        :agg_bkr_zk_connect => zookeeper_pairs * ",",
        :agg_bkr_zk_timeout_ms => node['wt_kafka_topagg']['agg_bkr_zk_timeout_ms'],
        :dc => datacenter,
        :pod => pod,
        :edge_kafka_sources => node['wt_kafka_topagg']['edge_kafka_sources'].to_json().gsub("[{", "[\n         {").gsub("}]", "}\n    ]").gsub("},{", "},\n         {")
    })
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
            :java_jmx_port => node['wt_kafka_topagg']['jmx_port'],
            :java_opts => java_opts
        })
    end

    # delete the application tarball
    execute "delete_install_source" do
        user "root"
        group "root"
        command "rm -f #{Chef::Config[:file_cache_path]}/#{tarball}"
        action :run
    end

    # create a runit service
    runit_service "topagg" do
        options({
            :log_dir => log_dir,
            :install_dir => install_dir,
            :java_home => java_home,
            :user => user
        })
    end
end

#Create collectd plugin for topagg JMX objects if collectd has been applied.
if node.attribute?("collectd")
    template "#{node['collectd']['plugin_conf_dir']}/collectd_topagg.conf" do
        source "collectd_topagg.conf.erb"
        owner "root"
        group "root"
        mode 00644
        notifies :restart, resources(:service => "collectd")
    end
end

if node.attribute?("nagios")
    #Create a nagios nrpe check for the healthcheck page
    nagios_nrpecheck "wt_healthcheck_page" do
        command "#{node['nagios']['plugin_dir']}/check_http"
        parameters "-H #{node['fqdn']} -u /healthcheck -p 9000 -r \"\\\"all_services\\\": \\\"ok\\\"\""
        action :add
    end
    
    #Create a nagios nrpe check for the log file
    nagios_nrpecheck "wt_garbage_collection_limit_reached" do
        command "#{node['nagios']['plugin_dir']}/check_log"
        parameters "-F /var/log/webtrends/topagg/#{node[:wt_kafka_topagg][:name]}.log -O /tmp/#{node[:wt_kafka_topagg][:name]}_old.log -q 'GC overhead limit exceeded'"
        action :add
    end
end
