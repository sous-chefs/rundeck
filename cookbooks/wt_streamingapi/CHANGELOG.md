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