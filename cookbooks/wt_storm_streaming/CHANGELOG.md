## 2.4.9
* Fixed service name

## 2.4.8
* Updated ZK timeout/retry settings in storm.yaml

## 2.4.7
* Added supported for restarting nimbus/webui post deploy

## 2.4.6
* Removed Visitor Analytics Dependency

## 2.4.5
* Added cache directory in conf directory.

## 2.4.4
* Provided support for restarting supervisors post deploy

## 2.4.3
* Added configurable augment bolt settings

## 2.4.2
* Updated curator framework version to v1.0.3

## 2.4.1
* Adding application.conf to configure the connectivity to hbase session
  history.

## 2.4.0
* Adding change to support scala-2.9.2, which requires the use of a kafka jar
  compiled with the scala-2.9.2 compiler.

## 2.3.9
* Changed "streaming.topology.zmq.data.znoderoot" in config.properties.erb to "streaming.topology.zmq.data.znode.root"

## 2.3.8
* Added new logic to remove old zookeeper jar file, and replace with the latest
  from streamig-analysis tarball.

## 2.3.7
* Added new versions of browsers.ini, keywords.ini, device-atlas.json

## 2.3.6
* Changed "streaming.topology.zmq.data.znoderoot" in config.properties.erb

## 2.3.5
* Adding new pull address for zmq.

## 2.3.4
* Adding new dep for guice-assisted injection.

## 2.3.3
* Removed unusued template variable

## 2.3.2
* Set default of saving the offset to ZK true.

## 2.3.1
* Fewer parameters and name changes to reflect code names.

## 2.3.0
* Made changes to actual attribute names and removed no longer used
  attributes to reflect code clean up in the topo code itself.

## 2.2.1
* Added "streaming.topology.zmq.data.znodeRoot" in config.properties.erb

## 2.2.0
* Adding new session stream code.

## 2.1.24
* Added the tasks parameters so the cookbook actually will work.

## 2.1.23
* Updated configuration, so that the tasks for each of the bolts is also now configurable and out of code.

## 2.1.22
* Updated the device-atlas file name and the file content.

## 2.1.21
* Remove extra streaming.topology.mode.local config.properties

## 2.1.20
* Fixed a bad character that looked like a -

## 2.1.19
* Changed the jvm setting defaults for the storm.yaml file

## 2.1.18
* Added convert_searchstr.ini to list of files installed in conf dir

## 2.1.17
* Changed the jvm setting for child opts and up the bolt counts.

## 2.1.16
* Never set node attributes directly.  Then we have to fix stuff later

## 2.1.15
* Fixes to be able to disable local grouping in the config.properties.

## 2.1.14
* Updated version of UserAgentUtils to 1.6 from 1.2.4

## 2.1.13
* Added convert_searchstr.ini file

## 2.1.12
* Remove unused nimbus host attribute since we search this out
* Cleanup some variables that we were setting as node attributes.  Now using plain old variables

## 2.1.11
* Using kafka-0.7.1 rather than kafka-0.7.2, but patched with the concurrency fix.

## 2.1.10
* Went back to kafka-0.7.1

## 2.1.9
* Remove antlr-2.7.7.jar and change kafka to 0.7.2. Updated CAM urls

## 2.1.8
* This cookbook is functionally equivalent to 2.1.7. Originally the
  change created a dep to kafka 0.7.2, but it should of gone to a
  different branch. Since the cookbook is already uploaded to
  chef the version will stay but dep has been removed.

## 2.1.7
* Created an attribute for the root logging level for log4j

## 2.1.6
* Changing back to kafka-0.7.1

## 2.1.5
* Added support for changing the field grouping and debug setting of a topo

## 2.1.4
* Making cookbook compatible with release artifact for streaming-1.0.1

## 2.1.3
* Address food critic warnings
* Remove fallback to attributes if Zookeeper search fails

## 2.1.2
* Added more cleanup logic

## 2.1.1
* Changed kafka to kafka_aggregator

## 2.1.0
* Added new version to fully separate out "storm streaming" and "storm realtime"

## 2.0.14
* Added cam url

# 2.0.13
* Removed whitelist, updated config service endpoint

# 2.0.12
* Added CAM Urls

# 2.0.11
* Remove broker chroot prefix from zk.connect string

# 2.0.10
* Fixes for STR-160 - TrafficSource and Browsers data not accurate"

# 2.0.9
* Tried adding a forced ZK 3.4.3 client, but did not work making this version equal to 2.0.8.

# 2.0.8
* Reverted, should now be the same as 2.0.7

# 2.0.7
* Added support to get a list of topics which include other datacenters

# 2.0.6
* Added browsers.ini file and the ini4j-0.5.2.jar

# 2.0.4
* Changed attribute name to reference wt_storm which is where the attributes live in the environment

# 2.0.3
* Removed misleading cluster_role from this cookbook as it wasn't getting used and we are setting that in the role.

# 2.0.1
* Added lookup files and cookbook to lay them down.

# 2.0.0
* Renamed wt_storm to wt_storm_realtime and wt_storm_streaming

# 1.0.38
* Added broker chroot prefix for zk.connect string

# 1.0.37
* Updated seed.data file for trafficsource changes

# 1.0.36
* Updated streaming_depoly.rb to also support storm 0.8.0

# 1.0.35
* Moved to storm 0.8.0 and added datacenter and pod prefixes to zookeeper
  paths

# 1.0.34
* Updated cookbook to support independent dcsid_whitelist parameters in
  the realtime and streaming topologies

# 1.0.33
* Updated seed.data file

# 1.0.32
* Added metadata-loader

# 1.0.31
* Added ANTLR libs

# 1.0.29
* attribute fixes to cookbook
* adding additional bolt parallelism attributes

# 1.0.29
* Moved the kafka topic parameter to environment file.

# 1.0.28
* Moved topology parameters from recepies to environment file.

# 1.0.27
* Removed delete of logs director

# 1.0.26
* Remove the default storm log directory since we use /var/storm

# 1.0.25
* The lost releases

# 1.0.24
* Added changes to support finding SAPI hosts via zookeeper

# 1.0.23
* Added support in the configuration for the "in session" bolt, though
  this feature may or may-not be enabled yet in code

# 1.0.22
* Added independent kafka configuration properties to allow for kafka to
  register with its own zookeeper

# 1.0.21
* Use the load balancer NetAcuity URL instead of searching for netacuity

# 1.0.12 - 1.0.20
* Who knows

# 1.0.11
* Added zookeeper client port support and standardized zookeeper processing

# 1.08
* Log to /var/log/storm not /opt/storm/current/logs

# 1.07
* Added collectd JRE stats

# 1.06
* Added auditing support

# 1.04
* Correctly search out the Kafka nodes by using the Kafka role

# 1.02-03
* Obviously something happened here

# 1.01
* added log4j file to cookbook
