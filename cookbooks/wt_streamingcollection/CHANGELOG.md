## 0.0.23
* Added broker chroot prefix for zk.connect string

## 0.0.22
* Changed logic to pull the tar file from the 'download_url' attribute

## 0.0.21
* Add garbage collection nagios check

## 0.0.20
* Changed topic name to scsRawHits

## 0.0.19
* Added a nagios healthcheck

## 0.0.18
* Externalized the healthcheck options 'healthcheck_enabled' to [:wt_monitoring][:healthcheck_enabled]
* Externalized the healthcheck options 'healthcheck_port' to [:wt_monitoring][:healthcheck_port]

## 0.0.17
* Added support for deploying changes to attributes that write to templates without having to re-deploy all the bits.

## 0.0.16
* Added template to create a collectd plugin to collect kafka JMX counters.

## 0.0.15
* Adding a property for the CAM url, so that we can do DCSID lookups from the cam as well as the dcsid2account service.

## 0.0.14
* Added auditing properties

## 0.0.13
* Added gate keeper for deploy using the deploy_build environment variable

## 0.0.12
* Removed 'tarball' attribute as it is included in the download_url
* Externalized the java options 'java_opts'
* Externalized the java options 'jmx_port' to [:wt_monitoring][:jmx_port]

## 0.0.11
* Moved monitoring attributes to wt_monitoring

## 0.0.10
* Searches for zookeeper were made using nodes that apply the zookeeper recipe. In our environment we
* apply a zookeeper role instead tso the search was changed to look for the role

## 0.0.9
* Changed kafka properties to use zookeeper nodes taken from the nodes that use zookeeper recipe

## 0.0.6
* Fix file mode declarations (best practice)
* Use the chef defined temp directory not /tmp (best practice)
* Additional comments
* Attributes are references with strings not symbols (best practice)


## 0.0.5:
* Initial release with a changelog