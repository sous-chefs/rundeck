
# Bits that are specific to __streaming__ that serve as the
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

kafka = search(:node, "role:kafka AND chef_environment:#{node.chef_environment}").first

pod = node[:wt_realtime_hadoop][:pod]
datacenter = node[:wt_realtime_hadoop][:datacenter]

node['wt_storm']['zookeeper_quorum'] = zookeeper_quorum
node['wt_storm']['nimbus']['host'] = search(:node, "role:storm_nimbus AND role:#{node['storm']['cluster_role']} AND chef_environment:#{node.chef_environment}").first[:fqdn]
node['wt_storm']['worker']['childopts'] = node['wt_storm']['streaming_topology']['worker']['childopts']
node['wt_storm']['zookeeper']['root'] = "/#{datacenter}_#{pod}_storm-streaming"
node['wt_storm']['transactional']['zookeeper']['root'] = "/#{datacenter}_#{pod}_storm-streaming-transactional"


template "#{node['storm']['install_dir']}/storm-#{node['storm']['version']}/conf/storm.yaml" do
  source "storm.yaml.erb"
  owner  "storm"
  group  "storm"
  mode   00644
  variables(
    :storm_config => node['wt_storm']
  )
end

template "#{node['storm']['install_dir']}/storm-#{node['storm']['version']}/conf/config.properties" do
  source "config.properties.erb"
  owner  "storm"
  group  "storm"
  mode   00644
  variables(
    :topology                                    => "streaming-topology",
    :streaming_topology_parsing_bolt_count       => node['wt_storm']['streaming_topology']['streaming_topology_parsing_bolt_count'],
    :streaming_topology_in_session_bolt_count    => node['wt_storm']['streaming_topology']['streaming_topology_in_session_bolt_count'],
    :streaming_topology_zmq_emitter_bolt_count   => node['wt_storm']['streaming_topology']['streaming_topology_zmq_emitter_bolt_count'],
    :streaming_topology_validation_bolt_count    => node['wt_storm']['streaming_topology']['streaming_topology_validation_bolt_count'],
    :streaming_topology_augmentation_bolt_count  => node['wt_storm']['streaming_topology']['streaming_topology_augmentation_bolt_count'],   
    # kafka consumer settings
    :kafka_consumer_topic                 => node['wt_storm']['streaming_topology']['kafka_consumer_topic'],
    :kafka_dcsid_whitelist                => node['wt_storm']['streaming_topology']['dcsid_whitelist'],
    :kafka_zookeeper_quorum               => zookeeper_quorum * ",",
    :kafka_consumer_group_id              => 'kafka-streaming',
    :kafka_zookeeper_timeout_milliseconds => 1000000,
    # non-storm parameters
    :zookeeper_quorum      => zookeeper_quorum * ",",
    :zookeeper_clientport  => zookeeper_clientport,
    :zookeeper_pairs       => zookeeper_quorum.map { |server| "#{server}:#{zookeeper_clientport}" } * ",",
    :cam                   => node[:wt_cam][:cam_server_url],
    :config_distrib        => node[:wt_configdistrib][:dcsid_url],
    :netacuity             => node[:wt_netacuity][:geo_url],
    :kafka                 => kafka[:fqdn],
    :pod                   => pod,
    :datacenter            => datacenter,
    :debug                 => node[:wt_storm][:debug],
    :audit_bucket_timespan => node[:wt_monitoring][:audit_bucket_timespan],
    :audit_topic           => node[:wt_monitoring][:audit_topic]
  )
end
