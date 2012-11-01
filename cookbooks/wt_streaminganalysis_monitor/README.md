= DESCRIPTION:
Installs Streaming Analysis Monitor Service

= REQUIREMENTS:
* java
* runit

= ATTRIBUTES:
* user: The user to run the service under
* group: The group to run the service under
* download_url: The fullpath, including the tarball, to the system build
* java_opts - Options to start java (e.g. "-Xms2048m -Djava.net.preferIPv4Stack=true")
* jmx_port: The port to run JMX on
* graphite_enabled: Should we push metrics to graphite
* graphite_interval: How often (minutes) should we flush metrics to graphite
* statuslistener.enabled: Are we listening to Storm status
* statuslistener.znode.root: What ZK node are we listening for
* metricslistener.enabled: Are we listening to metrics
* metricslistener.topic: The topic used for auditing (defaults to stream-audit)
* stats_interval: This is how often to call (seconds) Nimbus to retrieve statistics
* healthcheck_enabled: Are health checks enabled
* healthcheck_port: Which port will health checks be exposed
* cluster_role: The Storm cluster to to use when searching for the Nimbus box. Defaults to "wt_storm_streaming_topo".
= USAGE: