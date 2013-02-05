## 1.1.5
* Adding config cache directory.

## 1.1.4
* Fixed Nagios regular expression to be ignore whitespace

## 1.1.3
* Fix the syntax of the force-stop on uninstall

## 1.1.2
* Remove an unused "user" variable being passed into the service control erb
* Remove the hardcoded value for MAIN that was passed into the service control erb as a variable
* Resolve food critic warnings
* Use the same method of determining install_dir/log_dir in the uninstall as we use in the install

## 1.1.1
* Changed how the service-control script finds the LR process since it was
  broken.

## 1.1.0
* Renamed configuration files to match other services and changed template
  content to match naming convention of other services.

## 1.0.0
* Removed unused Kafka broker attribute from the attributes file
* Clean up deploy logging

## 0.0.28
* Updated collectd script to include two new metrics: files-in-queue and active-dcsid

## 0.0.27
* Added a reference to wt_streamingconfigservice. Im not sure if this was to be
  avoided, but the 0.0.26 version of the cookbook did not install in Hpod.

## 0.0.26
* Don't fall back to a valid TC URL

## 0.0.25
* Add an JMX port attribute and use that attribute vs the wt_monitoring jmx_port attribute
* Don't use attributes for kafka_topic and configservice_url that get overridden by the cookbook anyways
* Make sure the config files are templated the same way in both deploy and non-deploy mode

## 0.0.24
* Replaced static whitelist with url to config service endpoint

## 0.0.23
* Remove broker chroot prefix from zk.connect string

## 0.0.22
* Added new kafka_topic logic.

## 0.0.21
* Added broker chroot prefix for zk.connect string

## 0.0.20
* Changed logic to pull the tar file from the 'download_url' attribute

## 0.0.19
* Added the attribute

## 0.0.18
* Add garbage collection nagios check

## 0.0.17
* Added additional properties to support Zookeeper nodes, thread pool size, and a log file regular expression

## 0.0.16
* Added changes to kafka topic name to support "smoothing" of the stream

## 0.0.15
* Added zookeeper client port support and standardized zookeeper processing

##0.0.14
* Add a nagios healthcheck

## 0.0.13
* Added the attribute lock_check_period which determines how many minutes to wait before a local_lock file is considered to be "lost" and thus put back in the process

## 0.0.12
* Externalized the healthcheck options 'healthcheck_enabled' to ['wt_monitoring']['healthcheck_enabled']
* Externalized the healthcheck options 'healthcheck_port' to ['wt_monitoring']['healthcheck_port']

## 0.0.11
* Added support for deploying changes to attributes that write to templates without having to re-deploy all the bits.

## 0.0.10
* Added the attribute kafka_broker_list which allows a broker address to be used in lieu of finding zookeeper nodes. If setting the value it should look like '0:lasbkr.netiq.dmz:9092'
## 0.0.9
* Added a plugin template for collectd that gets applied in the default recipe.

## 0.0.8
* Added environment override for finding zookeeper nodes. The attribute is zookeeper_env and defaults to "", which means it
* will search in the local environment.

# 0.0.7
* Change default user/group to webtrends/webtrends

## 0.0.6
* Added auditing properties

## 0.0.5
* Don't run as root

## 0.0.4
* Modified the cookbook to mount a NFS volume from an attribute and to pull logs from that mount

## 0.0.3
* Added gate keeper for deploy using the deploy_build environment variable

## 0.0.2
* Renamed the cookbook from 'wt_streaminglogreplay' to 'wt_streaminglogreplayer'
* Removed 'tarball' attribute as it is included in the download_url
* Externalized the java options 'java_opts'
* Externalized the java options 'jmx_port' to ['wt_monitoring']['jmx_port']

## 0.0.1:
* Initial release
