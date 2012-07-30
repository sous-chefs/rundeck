
# Bits that are specific to __real-time__ that serve as the
# launchpad for topologies.  The idea is that supervisors
# should be completely homogenous, and only nimbus should
# require any topology specific bits.

# in the future this will pull builds from teamcity

include_recipe "wt_storm"

# grab the zookeeper port number if specified
zookeeper_clientport = node['zookeeper']['client_port']

# grab the zookeeper nodes that are currently available
zookeeper_quorum = Array.new
if not Chef::Config.solo
    search(:node, "role:zookeeper AND chef_environment:#{node.chef_environment}").each do |n|
        zookeeper_quorum << n[:fqdn]
    end
end

# fall back to attribs if search doesn't come up with any zookeeper nodes
if zookeeper_quorum.count == 0
    node[:zookeeper][:quorum].each do |i|
        zookeeper_quorum << i
    end
end

sapi = search(:node, "role:wt_streaming_api_server AND chef_environment:#{node.chef_environment}").first
kafka = search(:node, "role:kafka AND chef_environment:#{node.chef_environment}").first


template "#{node['storm']['install_dir']}/storm-#{node['storm']['version']}/conf/config.properties" do
  source "config.properties.erb"
  owner  "storm"
  group  "storm"
  mode   00644
  variables(
    :topology                                => "realtime-topology",
    :realtime_topology_parsing_bolt_count    => node['wt_storm']['realtime_topology']['realtime_topology_parsing_bolt_count'],
    :realtime_topology_row_key_bolt_count    => node['wt_storm']['realtime_topology']['realtime_topology_row_key_bolt_count'],
    :realtime_topology_writing_bolt_count    => node['wt_storm']['realtime_topology']['realtime_topology_writing_bolt_count'],
    :realtime_topology_dimensions_bolt_count => node['wt_storm']['realtime_topology']['realtime_topology_dimensions_bolt_count'],
    :topology_override_max_spout_pending     => node['wt_storm']['realtime_topology']['topology_override_max_spout_pending'],
    :topology_override_msg_timeout_seconds   => node['wt_storm']['realtime_topology']['topology_override_msg_timeout_seconds'],
    # kafka consumer settings
    :kafka_consumer_topic                 => node['wt_storm']['realtime_topology']['kafka_consumer_topic'],
    :kafka_dcsid_whitelist                => node['wt_storm']['dcsid_whitelist'],
    :kafka_zookeeper_quorum               => zookeeper_quorum * ",",
    :kafka_consumer_group_id              => 'kafka-realtime',
    :kafka_zookeeper_timeout_milliseconds => 1000000,
    # non-storm parameters
    :zookeeper_quorum      => zookeeper_quorum * ",",
    :zookeeper_clientport  => zookeeper_clientport,
    :zookeeper_pairs	   => zookeeper_quorum.map { |server| "#{server}:#{zookeeper_clientport}" } * ",",
    :cam                   => node[:wt_cam][:cam_server_url],
    :sapi                  => sapi[:fqdn],
    :config_distrib        => node[:wt_configdistrib][:dcsid_url],
    :netacuity             => node[:wt_netacuity][:geo_url],
    :kafka                 => kafka[:fqdn],
    :pod                   => node[:wt_realtime_hadoop][:pod],
    :datacenter            => node[:wt_realtime_hadoop][:datacenter],
    :debug                 => node[:wt_storm][:debug],
    :audit_bucket_timespan => node[:wt_monitoring][:audit_bucket_timespan],
    :audit_topic           => node[:wt_monitoring][:audit_topic]
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

cookbook_file "#{node['storm']['install_dir']}/storm-#{node['storm']['version']}/conf" do
  source "seed.data"
  mode "0644"
end

# template out the metadata loader
template "#{node['storm']['install_dir']}/storm-#{node['storm']['version']}/bin/metadata-loader" do
  source  "metadata-loader.erb"
  owner "storm"
  group "storm"
  mode  00644
  variables({
    :home_dir  => "#{node['storm']['install_dir']}/storm-#{node['storm']['version']}",
    :java_home => node['java']['java_home']
  })
nd
