#
# Cookbook Name:: wt_storm_streaming
# Recipe:: default
#
# Copyright 2012, Webtrends
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Get the storm base application installed
include_recipe "storm"

download_url = node['wt_storm_streaming']['download_url']
install_tmp = '/tmp/wt_storm_install'
tarball = 'streaming-analysis-bin.tar.gz'
nimbus_host = search(:node, "role:storm_nimbus AND role:#{node['storm']['cluster_role']} AND chef_environment:#{node.chef_environment}").first[:fqdn]

# grab the zookeeper port
zookeeper_clientport = node['zookeeper']['client_port']

# grab the zookeeper nodes that are currently available
zookeeper_quorum = Array.new
if not Chef::Config.solo
    search(:node, "role:zookeeper AND chef_environment:#{node.chef_environment}").each do |n|
        zookeeper_quorum << n['fqdn']
    end
end

kafka = search(:node, "role:kafka_aggregator AND chef_environment:#{node.chef_environment}").first
pod = node['wt_realtime_hadoop']['pod']
datacenter = node['wt_realtime_hadoop']['datacenter']
zookeeper_root = "/#{datacenter}_#{pod}_storm-streaming"
transactional_zookeeper_root = "/#{datacenter}_#{pod}_storm-streaming-transactional"

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

    # delete previous the install TEMP directory
    directory install_tmp do
      owner "root"
      group "root"
      mode 00755
      recursive true
      action :delete
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
    gson-2.2.2.jar
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
    jsp-2.1-6.1.14.jar
    jsp-api-2.1-6.1.14.jar
    kafka-0.7.1.1.jar
    libthrift-0.7.0.jar
    netty-3.3.0.Final.jar
    plexus-utils-1.5.6.jar
    protobuf-java-2.4.0a.jar
    regexp-1.3.jar
    scala-library-2.8.0.jar
    snappy-java-1.0.4.1.jar
    stax-api-1.0.1.jar
    streaming-analysis.jar
    UserAgentUtils-1.6.jar
    xmlenc-0.52.jar
    zkclient-0.1.jar
    mobi.mtld.da-1.5.3.jar
    ini4j-0.5.2.jar
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
end

# storm looks for storm.yaml in ~/.storm/storm.yaml so make a link
link "/home/storm/.storm" do
	to "#{node['storm']['install_dir']}/storm-#{node['storm']['version']}/conf"
end 

file "#{node['storm']['install_dir']}/storm-#{node['storm']['version']}/conf/storm.yaml" do
  owner "root"
  group "root"
  mode "00644"
  action :delete
end

# template the storm yaml file
template "#{node['storm']['install_dir']}/storm-#{node['storm']['version']}/conf/storm.yaml" do
  source "storm.yaml.erb"
  owner  "storm"
  group  "storm"
  mode   00644
  variables(
    :worker_childopts => node['wt_storm_streaming']['worker']['childopts'],
    :zookeeper_root => zookeeper_root,
    :transactional_zookeeper_root => transactional_zookeeper_root,
    :storm_config => node['wt_storm_streaming'],
    :zookeeper_quorum => zookeeper_quorum,
    :zookeeper_clientport  => zookeeper_clientport,
    :nimbus_host => nimbus_host
  )
end

# template the actual storm config file
template "#{node['storm']['install_dir']}/storm-#{node['storm']['version']}/conf/config.properties" do
  source "config.properties.erb"
  owner  "storm"
  group  "storm"
  mode   00644
  variables(
    # executor counts, ie: executor threads
    :streaming_topology_emitter_bolt_count => node['wt_storm_streaming']['streaming_topology_emitter_bolt_count'],
    :streaming_topology_augment_bolt_count => node['wt_storm_streaming']['streaming_topology_augment_bolt_count'],
    :streaming_topology_filter_bolt_count  => node['wt_storm_streaming']['streaming_topology_filter_bolt_count'],
    # task counts, ie: logical parallelism
    :streaming_topology_emitter_bolt_tasks => node['wt_storm_streaming']['streaming_topology_emitter_bolt_tasks'],
    :streaming_topology_augment_bolt_tasks => node['wt_storm_streaming']['streaming_topology_augment_bolt_tasks'],
    :streaming_topology_filter_bolt_tasks  => node['wt_storm_streaming']['streaming_topology_filter_bolt_tasks'],
    # kafka consumer settings
    :kafka_consumer_topic       => node['wt_storm_streaming']['topic_list'].join(','),
    :kafka_consumer_group_id    => node['wt_storm_streaming']['kafka']['consumer_group_id'],
    :kafka_zookeeper_timeout_ms => node['wt_storm_streaming']['kafka']['zookeeper_timeout_ms'],
    :kafka_auto_offset_reset    => node['wt_storm_streaming']['kafka']['auto_offset_reset'],
    # non-storm parameters
    :zookeeper_quorum      => zookeeper_quorum * ",",
    :zookeeper_clientport  => zookeeper_clientport,
    :configservice         => node['wt_streamingconfigservice']['config_service_url'],
    :netacuity             => node['wt_netacuity']['geo_url'],
    :pod                   => pod,
    :datacenter            => datacenter,
    :audit_zookeeper_pairs => zookeeper_quorum.map { |server| "#{server}:#{zookeeper_clientport}" } * ",",
    :audit_bucket_timespan => node['wt_monitoring']['audit_bucket_timespan'],
    :audit_topic           => node['wt_monitoring']['audit_topic'],
    :cam_url               => node['wt_cam']['cam_service_url']
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

%w{
botIP.csv
asn_org.csv
conn_speed_code.csv
city_codes.csv
country_codes.csv
metro_codes.csv
region_codes.csv
keywords.ini
device-atlas.json
browsers.ini
convert_searchstr.ini
}.each do |ini_file|
    cookbook_file "#{node['storm']['install_dir']}/storm-#{node['storm']['version']}/conf/#{ini_file}" do
      source ini_file
      mode 00644
    end
end
