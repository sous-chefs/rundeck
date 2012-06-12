## Future

* Unknown

## 0.0.9
* Added the attribute kafka_broker_list which allows a broker address to be used in lieu of finding zookeeper nodes. If setting the value it should look like '0:lasbkr.netiq.dmz:9092'
* and can be a comma delimited list of brokers. This defaults to nil so zookeeper will be the default.

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