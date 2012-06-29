
# Bits that are specific to __streaming__ that serve as the
# launchpad for topologies.  The idea is that supervisors
# should be completely homogenous, and only nimbus should
# require any topology specific bits.

# in the future this will pull builds from teamcity

include_recipe "wt_storm"

zk_quorum = search(:node, "role:zookeeper AND chef_environment:#{node['wt_realtime_hadoop']['environment']}") # Find zk quorum in the *declared* environment
sapi = search(:node, "role:wt_streaming_api_server AND chef_environment:#{node.chef_environment}").first
netacuity = search(:node, "role:wt_netacuity AND chef_environment:#{node.chef_environment}").first
kafka = search(:node, "role:kafka AND chef_environment:#{node.chef_environment}").first


template "#{node['storm']['install_dir']}/storm-#{node['storm']['version']}/conf/config.properties" do
  source "config.properties.erb"
  owner  "storm"
  group  "storm"
  mode   00644
  variables(
	:topology             => "streaming-topology",
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
    :audit_topic          => node[:wt_monitoring][:audit_topic]
  )
end