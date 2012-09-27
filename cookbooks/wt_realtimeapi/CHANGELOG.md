## 0.0.26
* Created an attribute for the root logging level for log4j

## 0.0.25
* Removed the force-stop from undeploy.rb

## 0.0.24
* Address food critic warnings
* Don't pass in a hardcoded java_class variable
* Don't use a hardcoded JMX port of 9998.  Use an attribute from within the realtime cookbook and set 9999 as we do everywhere else
* Removed unused user variable being passed into the service control template
* Find Zookeeper nodes via search and not using the deprecated quorum attribute in the ZK cookbook

## 0.0.23
* Don't fall back to a valid TC url
* Change the default port to 8080 to match our other products

## 0.0.23:
* Unknown

## 0.0.21
* Added the 'download_url' attribute

## 0.0.20
* Changed logic to pull the tar file from the 'download_url' attribute

## 0.0.19
* Removed entry to get latest successful, now using pinned versions

## 0.0.18
* Add garbage collection nagios check

## 0.0.17
* Added zookeeper client support and standardized zookeeper processing

## 0.0.16
* Added a nagios healthcheck

## 0.0.15
* Added code to create a collectd JMX plugin if collectd has been applied to the node.

## 0.0.14
* Externalized the healthcheck options 'healthcheck_enabled' to [:wt_monitoring][:healthcheck_enabled]
* Externalized the healthcheck options 'healthcheck_port' to [:wt_monitoring][:healthcheck_port]

## 0.0.13
* Added support for deploying changes to attributes that write to templates without having to re-deploy all the bits.

## 0.0.12
* Due to a search bug with windows nodes (which CAM is) use a hardcoded cam url attribute

## 0.0.11
* Search for a CAM node instead of using a bad attribute

## 0.0.10
* Added gate keeper for deploy using the deploy_build environment variable

## 0.0.9
* Removed 'tarball' attribute as it is included in the download_url
* Externalized the java options 'java_opts'
* Externalized the java options 'jmx_port' to [:wt_monitoring][:jmx_port]

## 0.0.8
* Moved monitoring attributes to wt_monitoring

## 0.0.7
* Turned monitoring on

## 0.0.6
* Fix file mode declarations (best practice)
* Use the chef defined temp directory not /tmp (best practice)
* Additional comments
* Attributes are references with strings not symbols (best practice)

## 0.0.5:
* Initial release with a changelog