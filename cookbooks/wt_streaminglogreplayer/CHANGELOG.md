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
* Externalized the healthcheck options 'healthcheck_enabled' to [:wt_monitoring][:healthcheck_enabled]
* Externalized the healthcheck options 'healthcheck_port' to [:wt_monitoring][:healthcheck_port]

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
* Externalized the java options 'jmx_port' to [:wt_monitoring][:jmx_port]

## 0.0.1:
* Initial release