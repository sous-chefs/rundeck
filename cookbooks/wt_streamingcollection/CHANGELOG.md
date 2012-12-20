## 1.1.3
* Food critic warning

## 1.1.2
* Fix the force-stop syntax for the uninstall

## 1.1.1
* Same as 1.1.0, it was a failed experiment.

## 1.1.0
* Changed to use localhost kafka and no zookeeper rather in line
  with the "end state for collection" vision.

## 1.0.4
* added a minitest-handler based healtcheck
  
## 1.0.3
* Remove file response.txt added in 1.0.2

## 1.0.2
* Add conf/fileResponse.txt file

## 1.0.1
* Add config directory to classpath in service control script

## 1.0.0
* Clean up deploy logging
* Change port attribute from string to int

## 0.0.29
* Use a jmx_port attribute within the cookbook and not in wt_monitoring

## 0.0.28
* Don't fallback to Zookeeper quorum attributes if search fails.  If search fails we have bigger issues
* Address food critic warnings
* Remove an unused template attribute in the service control template (user)
* Remove the java_class attribute from the service control template since it's just hardcoded

## 0.0.27
* Don't fall back to a valid TC URL

## 0.0.26
* Change config option configserver.dcsids.url to configservice.whitelist.url
* Removing server url config option that is no longer used

## 0.0.25
* Remove broker chroot prefix for zk.connect and audit.zkconnect strings

## 0.0.24
* Added broker chroot prefix for audit.zk.connect string

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
