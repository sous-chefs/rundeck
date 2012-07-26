= DESCRIPTION:
Installs Streaming Auditor Service

= REQUIREMENTS:
* java
* runit
* nagios
* collectd

= ATTRIBUTES:
* user: The user to run the service under. Defaults to "webtrends"
* group: The group to run the service under. Defaults to "webtrends"
* download_url: The fullpath, including the tarball, to the system build
* java_opts - Options to start java (e.g. "-Xms2048m -Djava.net.preferIPv4Stack=true"). Defaults to "-Xms1024m -Djava.net.preferIPv4Stack=true"
* auditlistener_enabled - Is the audit listener enabled. Defaults to false.
* auditlistener_threads - How many threads to use when listening to records off of Kafka. Defaults to 4.
* roundtrip_interval - Minimum interval (seconds) to send roundtrip audit events through SCS. Defaults to 1.
* roundtrip_token - The old CAM token used to connect up to a SAPI socket to monitor roundtrip events
* roundtrip_tagserver_url - The tag server URL to send audit events to. Defaults to "http://statse.webtrendslive.com"
* roundtrip_scs_url - The SCS URL to send audit events to. Defaults to "http://scs.webtrends.com".
* roundtrip_tagserver_timeout - The timeout (minutes) to wait for receiving an event back before erroring out. Defaults to 15 minutes. 
* roundtrip_scs_timeout - The timeout (minutes) to wait for receiving an event back before erroring out. Defaults to 2 minutes. 

* wt_realtime_hadoop:datacenter - The datacenter this is deployed in
* wt_realtime_hadoop:pod - The pod this is deployed in
* wt_monitoring :jmx_port - The JMX port

= USAGE: