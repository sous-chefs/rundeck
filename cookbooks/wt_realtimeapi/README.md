= DESCRIPTION:
Installs Realtime API Service

= REQUIREMENTS:
* java
* runit

= ATTRIBUTES:
* user: The user to run the service under
* group: The group to run the service under
* download_url: The fullpath, including the tarball, to the system build
* port - The port to run on
* java_opts - Options to start java (e.g. "-Xms2048m -Djava.net.preferIPv4Stack=true")
* jmx_port: the port to expose JMX metrics on


= USAGE: