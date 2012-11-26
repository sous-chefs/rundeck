= DESCRIPTION:
Installs the Webtrends Streaming Management Service

= REQUIREMENTS:
* java cookbook
* runit cookbook

= ATTRIBUTES:
* user: The user to run the service under
* group: The group to run the service under
* java_home: The location of the JRE on the system
* download_url: The fullpath, including the tarball, to the system build
* java_opts - Options to start java (e.g. "-Xms2048m -Djava.net.preferIPv4Stack=true")


= USAGE: