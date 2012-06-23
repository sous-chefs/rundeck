
include_recipe "storm"


#############################################################################
# Storm jars

# May make sense to move this into realtime_deploy.rb and streaming_deploy.rb
# if the jar dependencies for each storm cluster diverge.

# Before adding a jar here make sure it's in the repo (i.e.-
# http://repo.staging.dmz/repo/linux/storm/jars/), otherwise the run
# of chef-client will fail

%w{
activation-1.1.jar
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
concurrentlinkedhashmap-lru-1.2.jar
fastutil-6.4.4.jar
groovy-all-1.7.6.jar
gson-2.1.jar
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
javax.inject.jar
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
user-agent-utils-1.2.4.jar
webtrends.hbase.jar
webtrends.core.jar
webtrends.monitoring.jar
webtrends.authentication.jar
webtrends.auditing.serialization.jar
webtrends.auditing.jar
wurfl-1.4.0.1.jar
xmlenc-0.52.jar
zkclient-0.1.jar
}.each do |jar|
  remote_file "#{node['storm']['install_dir']}/storm-#{node['storm']['version']}/lib/#{jar}" do
    source "#{node['wt_storm']['download_url']}/#{jar}"
    owner "storm"
    group "storm"
    mode "0644"
  end
end


template "#{node['storm']['install_dir']}/storm-#{node['storm']['version']}/log4j/storm.log.properties" do
  source  "storm.log.properties.erb"
  owner "storm"
  group "storm"
  mode  "00644"
  variables({
  })
end

# storm looks for storm.yaml in ~/.storm/storm.yaml
link "/home/storm/.storm" do
  to "#{node['storm']['install_dir']}/storm-#{node['storm']['version']}/conf"
end


# log4j

cookbook_file "#{node['storm']['install_dir']}/storm-#{node['storm']['version']}/log4j/storm.log.properties" do
  source "storm.log.properties"
  owner "storm"
  group "storm"
  mode 00644
end


