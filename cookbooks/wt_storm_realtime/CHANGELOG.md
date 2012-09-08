# 2.1.1
* Modified cs.url and added back whitelist setting

# 2.1.0
* Finished splitting storm_streaming and storm_realtime

# 2.0.10 
* updated cs.url and removed whitelist setting

# 2.0.9
* Cleaned up storm and kafka zk configs

# 2.0.8
* Removed broker chroot prefix from zk.connect string and audit.zk.connect string

# 2.0.7
* Added broker chroot prefix for audit.zk.connect string

# 2.0.6
*  Added browsers.ini support and ini4j-0.5.2.jar

# 2.0.4
*  Changed attribute name to reference wt_storm which is where the attributes live in the environment

# 2.0.3
*  Removed misleading cluster_role from this cookbook as it wasn't getting used and we are setting that in the role.

# 2.0.1
*  Added lookup files and cookbook to lay them down.

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
