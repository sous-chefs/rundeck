= DESCRIPTION:
Installs Streaming Auditor Service

= REQUIREMENTS:
* java
* runit

= ATTRIBUTES:
* user: The user to run the service under
* group: The group to run the service under
* download_url: The fullpath, including the tarball, to the system build
* listener_threads: The number of threads to use for monitoring the auditing records. Defaults to 4.
* java_opts - Options to start java (e.g. "-Xms2048m -Djava.net.preferIPv4Stack=true")


= USAGE: