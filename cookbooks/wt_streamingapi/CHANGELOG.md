## 1.2.4
* Removed use of collectd for metrics and replaced with built-in monitoring. The monitoring.properties was also merged into config.properties

## 1.2.3
* Pulled out jar verison check and created wt_base recipe

## 1.2.1
* Updated the location of value stored
## 1.2.0
* Added command to pull jar version and store as node attribute

## 1.1.5
* Changed Nagios check from port 9000 to 8080

## 1.1.4
* Fixed Nagios regular expression to be ignore whitespace

## 1.1.3
* Fix force-stop syntax on uninstall

## 1.1.2
* Added exploratory parameters: explore_timeout and explore_quietperiod

## 1.1.1
* Added a check when ['wt_common']['http_proxy_url'] is not set to SAPI will work in environments where there is no proxy

## 1.1.0
* Fixed food critic issues

## 1.0.12
* Changed 'webtrends.cam.streamType' to use the plural

## 1.0.11
* Resolved issues with the collectd configuration that pulls from JMX

## 1.0.10
* Added 'sauth_version'

## 1.0.9
* Added new way to get just the host part of the URI

## 1.0.8
* Updated auth url

## 1.0.7
* Add CAM product detail url config to the streaming.properties file to fix the healthcheck

## 1.0.6
* Fixed the auth url due to changes in the auth endpoints

## 1.0.5
* Remerge of the 0.0.41 build to the Streaming 1.1 branch

## 1.0.4
* Change the port attribute from a string to an int
* Remove the force on the package install for zmq

## 1.0.3
* Moving variables back to inside the def processTemplates

## 1.0.2
* Using data from node rather then as a variable

## 1.0.1
* Changing gsub method

## 1.0.0
* Changed [wt_cam][auth_service_url] to [wt_sauth][auth_service_url]
* Fixed spacing
* Moved templates to outside deploy gate

## 0.0.41
* Use the proxy url in wt_common instead of a local attribute

## 0.0.40
* Added support for proxy settings.

## 0.0.39
* Add ulimit file limit increase to 4096 to the runit exec script

## 0.0.38
* Moved nofile to the wt_streaming_api_server role by way of the ulimit cookbook

## 0.0.37
* Added configuration for the new streaming endpoints in CAM

## 0.0.36
* Created an attribute for the root logging level for log4j

## 0.0.35
* Removed the force-stop from undeploy.rb

## 0.0.34
* Added log4j.xml to cookbook rather than pulling from build

## 0.0.33
* Address food critic warnings
* Remove Zookeeper fallback to attributes

## 0.0.32
* Remove the fallback URL for download_url

## 0.0.31
* Changed usage database credentials source to data bag

## 0.0.30
* Fixed missing logic for the usage database connection

## 0.0.29
* Added usage db connection string

## 0.0.28
* Added cam url

## 0.0.27
*  Added directory creation for conf directory

## 0.0.26
*  Updated netty configuration

## 0.0.24
* Added broker chroot prefix for zk.connect string

## 0.0.23
  Added JVM options and netty configuration.

## 0.0.22
  Commented out the pam code as it appears to be breaking the system, perhaps stepping on likewise

## 0.0.21
* Changed logic to pull the tar file from the 'download_url' attribute

## 0.0.20
* Stepping up nofile

## 0.0.19
* Exposing writeBufferHighWaterMark as an attribute and increasing default size

## 0.0.18
* Add garbage collection nagios check

## 0.0.17
* Who knows

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
* Moved off of JSVC
* runit scripts updated to allow for nono-JSVC start

## 0.0.6
* Fix file mode declarations (best practice)
* Use the chef defined temp directory not /tmp (best practice)
* Additional comments
* Attributes are references with strings not symbols (best practice)

## 0.0.5:
* Initial release with a changelog
