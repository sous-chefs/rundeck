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
