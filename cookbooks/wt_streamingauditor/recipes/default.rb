#
# Cookbook Name:: wt_streamingauditor
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
    include_recipe "wt_streamingauditor::undeploy"
else
    log "The deploy_build value is not set or is false so we will only update the configuration"
end

log_dir      = File.join(node['wt_common']['log_dir_linux'], "streamingauditor")
install_dir  = File.join(node['wt_common']['install_dir_linux'], "streamingauditor")

download_url = node['wt_streamingauditor']['download_url']
tarball      = node['wt_streamingauditor']['download_url'].split("/")[-1]
java_home    = node['java']['java_home']
user         = node['wt_streamingauditor']['user']
group        = node['wt_streamingauditor']['group']
java_opts    = node['wt_streamingauditor']['java_opts']
jmx_port     = node['wt_streamingauditor']['jmx_port']

pod = node['wt_realtime_hadoop']['pod']
datacenter = node['wt_realtime_hadoop']['datacenter']
kafka_chroot_suffix = node['kafka']['chroot_suffix']

auth_data = data_bag_item('authorization', node.chef_environment)
client_id = auth_data['wt_streamingauditor']['client_id']
client_secret = auth_data['wt_streamingauditor']['client_secret']

log "Install dir: #{install_dir}"
log "Log dir: #{log_dir}"

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

def processTemplates (install_dir, node, datacenter, pod, kafka_chroot_suffix, client_id, client_secret)
	log "Updating the template files"

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
		zookeeper_pairs[i] = zookeeper_pairs[i].concat(":#{node['zookeeper']['client_port']}")
		i += 1
	end

	template "#{install_dir}/conf/kafka.properties" do
		source  "kafka.properties.erb"
		owner   "root"
		group   "root"
		mode    00644
		variables({
			:zookeeper_pairs => zookeeper_pairs,
			:kafka_chroot => "/#{datacenter}_#{pod}_#{kafka_chroot_suffix}"
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
				:wt_streamingauditor => node['wt_streamingauditor'],
				:wt_monitoring => node['wt_monitoring'],
				:wt_cam => node['wt_cam'],
				:kafka_chroot => "/#{datacenter}_#{pod}_#{kafka_chroot_suffix}",
				:pod => pod,
				:datacenter => datacenter,
				:client_id => client_id,
				:client_secret => client_secret
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
			:java_jmx_port => jmx_port,
			:java_opts => java_opts
		})
	end

	processTemplates(install_dir, node, datacenter, pod, kafka_chroot_suffix, client_id, client_secret)

	# delete the application tarball
	execute "delete_install_source" do
		user "root"
		group "root"
		command "rm -f #{Chef::Config[:file_cache_path]}/#{tarball}"
		action :run
	end

	# create a runit service
	runit_service "streamingauditor" do
		options({
			:log_dir => log_dir,
			:install_dir => install_dir,
			:java_home => java_home,
			:user => user
		})
	end
else
    processTemplates(install_dir, node, datacenter, pod, kafka_chroot_suffix, client_id, client_secret)
end

#Create collectd plugin for streaming auditor JMX objects if collectd has been applied.
if node.attribute?("collectd")
  template "#{node['collectd']['plugin_conf_dir']}/collectd_streamingauditor.conf" do
    source "collectd_streamingauditor.conf.erb"
    owner "root"
    group "root"
    mode 00644
    notifies :restart, resources(:service => "collectd")
    variables({
        :scs_urls => node['wt_streamingauditor']['roundtrip_scs_urls'].split(','),
        :ts_urls => node['wt_streamingauditor']['roundtrip_tagserver_url'].split(',')
    })
  end
end

if node.attribute?("nagios")
  #Create a nagios nrpe check for the healthcheck page
	nagios_nrpecheck "wt_healthcheck_page" do
		command "#{node['nagios']['plugin_dir']}/check_http"
		parameters "-H #{node['fqdn']} -u /healthcheck -p 9000 -r \"\\\"all_services\\\": \\\"ok\\\"\""
		action :add
	end

    # Create a nagios nrpe check for the overall streaming health
	nagios_nrpecheck "wt_streaming_healthcheck" do
		command "#{node['nagios']['plugin_dir']}/check_http"
		parameters "-H #{node['fqdn']} -u /healthcheck -p 9000 -r \"\\\"streaming_healthcheck\\\":\\{\\\"healthy\\\": \\\"true\\\"\""
		action :add
	end
end