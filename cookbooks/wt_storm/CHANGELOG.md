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
