= DESCRIPTION:
Installs Webtrends Streaming Auditor Service

= REQUIREMENTS:
* java
* runit

= ATTRIBUTES:
* user: The user to run the service under. Defaults to "webtrends"
* group: The group to run the service under. Defaults to "webtrends"
* download_url: The fullpath, including the tarball, to the system build
* java_opts - Options to start java (e.g. "-Xms2048m -Djava.net.preferIPv4Stack=true"). Defaults to "-Xms1024m -Djava.net.preferIPv4Stack=true"
* jmx_port - The JMX port. Defaults to 9999
* sauth_version - The version of authentication service to call. Defaults to "v1"
* auditlistener_enabled - Is the audit listener enabled. Defaults to false.
* roundtrip_interval - Minimum interval (seconds) to send roundtrip audit events through SCS. Defaults to 1.
* roundtrip_scs_dcsid - The DCSID to use when sending events through SCS"
* roundtrip_scs_urls - The SCS URLs to send audit events to.
* roundtrip_tagserver_dcsid - The DCSID to use when sending events through TagServer"
* roundtrip_tagserver_url - The tag server URL to send audit events to. Defaults to "http://statse.webtrendslive.com"
* roundtrip_tagserver_timeout - The timeout (minutes) to wait for receiving an event back before erroring out. Defaults to 15 minutes.
* roundtrip_scs_timeout - The timeout (minutes) to wait for receiving an event back before erroring out. Defaults to 2 minutes.

= USAGE: