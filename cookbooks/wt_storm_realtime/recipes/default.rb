# Get the storm base application installed
include_recipe "storm"

download_url = node['wt_storm_realtime']['download_url']
install_tmp = '/tmp/wt_storm_install'
tarball = 'streaming-analysis-bin.tar.gz'

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
kafka_chroot_suffix = node[:kafka][:chroot_suffix]

# Perform some really funky overrides that should never be done and need to be removed
node['wt_storm_realtime']['zookeeper_quorum'] = zookeeper_quorum
node['wt_storm_realtime']['nimbus']['host'] = search(:node, "role:storm_nimbus AND role:#{node['storm']['cluster_role']} AND chef_environment:#{node.chef_environment}").first[:fqdn]
node['wt_storm_realtime']['worker']['childopts'] = node['wt_storm_realtime']['realtime_topology']['worker']['childopts']
node['wt_storm_realtime']['zookeeper']['root'] = "/#{datacenter}_#{pod}_storm-realtime"
node['wt_storm_realtime']['transactional']['zookeeper']['root'] = "/#{datacenter}_#{pod}_storm-realtime-transactional"

#############################################################################
# Storm jars

# Before adding a jar here make sure it's in the repo (i.e.-
# http://repo.staging.dmz/repo/linux/storm/jars/), otherwise the run
# of chef-client will fail

# Perform a deploy if the deploy flag is set
if ENV["deploy_build"] == "true" then
    log "The deploy_build value is true so we will grab the tar ball and install"

    # grab the source file
    remote_file "#{Chef::Config[:file_cache_path]}/#{tarball}" do
      source download_url
      mode 00644
    end

    # create the install TEMP dirctory
    directory install_tmp do
      owner "root"
      group "root"
      mode 00755
      recursive true
    end

    # extract the source file into TEMP directory
    execute "tar" do
      user  "root"
      group "root"
      cwd install_tmp
      creates "#{install_tmp}/lib"
      command "tar zxvf #{Chef::Config[:file_cache_path]}/#{tarball}"
    end

    execute "mv" do
      user  "root"
      group "root"
      command "mv #{install_tmp}/lib/webtrends*.jar #{node['storm']['install_dir']}/storm-#{node['storm']['version']}/lib/"
    end

    execute "chown" do
      user  "root"
      group "root"
      command "chown storm:storm #{node['storm']['install_dir']}/storm-#{node['storm']['version']}/lib/webtrends*.jar"
    end

%w{
activation-1.1.jar
antlr-2.7.7.jar
antlr-3.4.jar
antlr-runtime-3.4.jar
aopalliance-1.0.jar
avro-1.5.3.jar
avro-ipc-1.5.3.jar
commons-cli-1.2.jar
commons-collections-3.2.1.jar
commons-configuration-1.6.jar
commons-el-1.0.jar
commons-httpclient-3.1.jar
commons-math-2.1.jar
commons-net-1.4.1.jar
curator-framework-1.0.1.jar
curator-recipes-1.1.10.jar
fastutil-6.4.4.jar
groovy-all-1.7.6.jar
guice-3.0.jar
hadoop-core-1.0.0.jar
hamcrest-core-1.1.jar
hbase-0.92.0.jar
high-scale-lib-1.1.1.jar
jackson-core-asl-1.9.3.jar
jackson-jaxrs-1.5.5.jar
jackson-mapper-asl-1.9.3.jar
jackson-xc-1.5.5.jar
JavaEWAH-0.5.0.jar
javax.inject-1.jar
jdom-1.1.jar
jersey-core-1.4.jar
jersey-json-1.4.jar
jersey-server-1.4.jar
jettison-1.1.jar
jopt-simple-3.2.jar
jsp-2.1-6.1.14.jar
jsp-api-2.1-6.1.14.jar
kafka-0.7.0.jar
libthrift-0.7.0.jar
netty-3.3.0.Final.jar
plexus-utils-1.5.6.jar
protobuf-java-2.4.0a.jar
regexp-1.3.jar
scala-library-2.8.0.jar
snappy-java-1.0.3.2.jar
stax-api-1.0.1.jar
storm-kafka-0.7.2-snaptmp8.jar
streaming-analysis.jar
UserAgentUtils-1.2.4.jar
wurfl-1.4.0.1.jar
xmlenc-0.52.jar
zkclient-0.1.jar
}.each do |jar|
      execute "mv" do
        user  "root"
        group "root"
        command "mv #{install_tmp}/lib/#{jar} #{node['storm']['install_dir']}/storm-#{node['storm']['version']}/lib/#{jar}"
      end

      execute "chown" do
        user  "root"
        group "root"
        command "chown storm:storm #{node['storm']['install_dir']}/storm-#{node['storm']['version']}/lib/#{jar}"
      end
    end

    directory install_tmp do
      action :delete
      recursive true
    end

end

##############################################
# Perform actions that will happen on each run

# create the log directory
directory "/var/log/storm" do
	action :create
	owner "storm"
	group "storm"
	mode 00755
end

# template out the log4j config with our custom logging settings
template "#{node['storm']['install_dir']}/storm-#{node['storm']['version']}/log4j/storm.log.properties" do
	source  "storm.log.properties.erb"
	owner "storm"
	group "storm"
	mode  00644
	variables({
	})
end

# storm looks for storm.yaml in ~/.storm/storm.yaml so make a link
link "/home/storm/.storm" do
	to "#{node['storm']['install_dir']}/storm-#{node['storm']['version']}/conf"
end

# template the storm yaml file
template "#{node['storm']['install_dir']}/storm-#{node['storm']['version']}/conf/storm.yaml" do
  source "storm.yaml.erb"
  owner  "storm"
  group  "storm"
  mode   00644
  variables(
    :storm_config => node['wt_storm_realtime']
  )
end

# template the actual storm config file
template "#{node['storm']['install_dir']}/storm-#{node['storm']['version']}/conf/config.properties" do
  source "config.properties.erb"
  owner  "storm"
  group  "storm"
  mode   00644
  variables(
    :topology                                => "realtime-topology",
    :realtime_topology_parsing_bolt_count    => node['wt_storm_realtime']['realtime_topology']['realtime_topology_parsing_bolt_count'],
    :realtime_topology_writing_bolt_count    => node['wt_storm_realtime']['realtime_topology']['realtime_topology_writing_bolt_count'],
    :realtime_topology_dimensions_bolt_count => node['wt_storm_realtime']['realtime_topology']['realtime_topology_dimensions_bolt_count'],
    :topology_override_max_spout_pending     => node['wt_storm_realtime']['realtime_topology']['topology_override_max_spout_pending'],
    :topology_override_msg_timeout_seconds   => node['wt_storm_realtime']['realtime_topology']['topology_override_msg_timeout_seconds'],
    # kafka consumer settings
    :kafka_chroot                         => "/#{datacenter}_#{pod}_#{kafka_chroot_suffix}",
    :kafka_consumer_topic                 => node['wt_storm_realtime']['realtime_topology']['kafka_consumer_topic'],
    :kafka_dcsid_whitelist                => node['wt_storm_realtime']['realtime_topology']['dcsid_whitelist'],
    :kafka_zookeeper_quorum               => zookeeper_quorum * ",",
    :kafka_consumer_group_id              => 'kafka-realtime',
    :kafka_zookeeper_timeout_milliseconds => 1000000,
    # non-storm parameters
    :zookeeper_quorum      => zookeeper_quorum * ",",
    :zookeeper_clientport  => zookeeper_clientport,
    :zookeeper_pairs	   => zookeeper_quorum.map { |server| "#{server}:#{zookeeper_clientport}" } * ",",
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

cookbook_file "#{node['storm']['install_dir']}/storm-#{node['storm']['version']}/conf/seed.data" do
  source "seed.data"
  mode 00644
end

# template out the metadata loader
template "#{node['storm']['install_dir']}/storm-#{node['storm']['version']}/bin/metadata-loader" do
  source  "metadata-loader.erb"
  owner "storm"
  group "storm"
  mode  00755
  variables({
    :home_dir  => "#{node['storm']['install_dir']}/storm-#{node['storm']['version']}",
    :java_home => node['java']['java_home']
  })
end