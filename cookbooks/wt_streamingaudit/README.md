= DESCRIPTION:
Installs Streaming Auditor Service

= REQUIREMENTS:
* java
* runit

= ATTRIBUTES:
* user: The user to run the service under
* group: The group to run the service under
* tarball: The tarball containing the system build
* download_url: The fullpath, including the tarball, to the system build
* listener_threads: The number of threads to use for monitoring the auditing records. Defaults to 4.

= USAGE: