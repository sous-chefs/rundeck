
# Bits that are specific to __real-time__ that serve as the
# launchpad for topologies.  The idea is that supervisors
# should be completely homogenous, and only nimbus should
# require any topology specific bits.

# in the future this will pull builds from teamcity

include_recipe "wt_storm"

zookeeper_clientport = node['zookeeper']['client_port']
zookeeper_quorum = search(:node, "role:zookeeper AND chef_environment:#{node.chef_environment}")

# fall back to attribs if search doesn't come up with any zookeeper nodes
if zookeeper_quorum.count == 0
    node[:zookeeper][:quorum].each do |i|
        zookeeper_quorum << i
    end
end

sapi = search(:node, "role:wt_streaming_api_server AND chef_environment:#{node.chef_environment}").first
netacuity = search(:node, "role:wt_netacuity AND chef_environment:#{node.chef_environment}").first
kafka = search(:node, "role:kafka AND chef_environment:#{node.chef_environment}").first


template "#{node['storm']['install_dir']}/storm-#{node['storm']['version']}/conf/config.properties" do
  source "config.properties.erb"
  owner  "storm"
  group  "storm"
  mode   00644
  variables(
    :topology => "realtime-topology",
    :realtime_topology_parsing_bolt_count    => 3,
    :realtime_topology_row_key_bolt_count    => 12,
    :realtime_topology_writing_bolt_count    => 48,
    :realtime_topology_dimensions_bolt_count => 3,
    :topology_override_max_spout_pending => 3000,
    :topology_override_msg_timeout_seconds => 120,
    :zookeeper_quorum      => zookeeper_quorum.map { |server| server[:fqdn] } * ",",
    :zookeeper_clientport  => zookeeper_clientport,
    :zookeeper_pairs	   => zookeeper_quorum.map { |server| "#{server[:fqdn]}:#{zookeeper_clientport}" } * ",",
    :cam                   => node[:wt_cam][:cam_server_url],
    :sapi                  => sapi[:fqdn],
    :config_distrib        => node[:wt_configdistrib][:dcsid_url],
    :netacuity             => netacuity[:fqdn],
    :kafka                 => kafka[:fqdn],
    :pod                   => node[:wt_realtime_hadoop][:pod],
    :datacenter            => node[:wt_realtime_hadoop][:datacenter],
    :dcsid_whitelist       => node[:wt_storm][:dcsid_whitelist],
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