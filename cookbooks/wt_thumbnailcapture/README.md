= DESCRIPTION:
Installs Thumbnail Capture Service

= REQUIREMENTS:
* java
* runit
* cutycapt
* xvfb
* dpyinfo

= ATTRIBUTES:
* user: The user to run the service under
* group: The group to run the service under
* download_url: The fullpath, including the tarball, to the system build
* display_idx: The available x-server screen location (default=1)
* jmx_port: port to publish JMX metrics to
* graphite_enabled: push counters to graphite
* graphite_interval: how often to push (minutes)
* graphite_regex: filter

= USAGE:
"/etc/init.d/screencap" start
sv start thumbnailcapture

