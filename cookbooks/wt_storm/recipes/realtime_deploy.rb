
# Bits that are specific to __real-time__ that serve as the
# launchpad for topologies.  The idea is that supervisors
# should be completely homogenous, and only nimbus should
# require any topology specific bits.

# in the future this will pull builds from teamcity

include_recipe "wt_storm"

zk_quorum = search(:node, "role:zookeeper AND chef_environment:#{node['wt_realtime_hadoop']['environment']}") # Find zk quorum in the *declared* environment
sapi = search(:node, "role:wt_streaming_api_server AND chef_environment:#{node.chef_environment}").first
netacuity = search(:node, "role:wt_netacuity AND chef_environment:#{node.chef_environment}").first
kafka = search(:node, "role:kafka AND chef_environment:#{node.chef_environment}").first

log "Updating the template files"

# get the correct environment for the zookeeper nodes
zookeeper_port = node['zookeeper']['client_port']
zookeeper_env = "#{node.chef_environment}"
unless node[:wt_streaminglogreplayer][:zookeeper_env].nil? || node[:wt_streaminglogreplayer][:zookeeper_env].empty?
    zookeeper_env = node['wt_streaminglogreplayer']['zookeeper_env']
end

# grab the zookeeper nodes that are currently available
zookeeper_pairs = Array.new
if not Chef::Config.solo
    search(:node, "role:zookeeper AND chef_environment:#{zookeeper_env}").each do |n|
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

template "#{node['storm']['install_dir']}/storm-#{node['storm']['version']}/conf/config.properties" do
  source "config.properties.erb"
  owner  "storm"
  group  "storm"
  mode   00644
  variables(
    :topology             => "realtime-topology",
    :zk_quorum            => zk_quorum.map { |server| server[:fqdn] } * ",",
    :cam                  => node[:wt_cam][:cam_server_url],
    :sapi                 => sapi[:fqdn],
    :config_distrib       => node[:wt_configdistrib][:dcsid_url],
    :netacuity            => netacuity[:fqdn],
    :kafka                => kafka[:fqdn],
    :pod                  => node[:wt_realtime_hadoop][:pod],
    :datacenter           => node[:wt_realtime_hadoop][:datacenter],
    :dcsid_whitelist      => node[:wt_storm][:dcsid_whitelist],
    :debug                => node[:wt_storm][:debug],
    :audit_bucket_timespan => node[:wt_monitoring][:audit_bucket_timespan],
    :audit_topic          => node[:wt_monitoring][:audit_topic],
    :zookeeper_pairs      => zookeeper_pairs
  )
end

template "#{node['storm']['install_dir']}/storm-#{node['storm']['version']}/conf/log4j.properties" do
  source "log4j.properties.erb"
  owner  "storm"
  group  "storm"
  mode   00644
  variables(
  )
end

template "#{node['storm']['install_dir']}/storm-#{node['storm']['version']}/bin/service-control" do
  source "service-control.erb"
  owner  "storm"
  group  "storm"
  mode   00755
  variables(
	:home_dir  => "#{node['storm']['install_dir']}/storm-#{node['storm']['version']}",
    :java_home => node['java']['java_home']
  )
end