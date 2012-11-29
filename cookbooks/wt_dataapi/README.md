= DESCRIPTION:
Installs Data API Service

= REQUIREMENTS:
* java
* runit

= ATTRIBUTES:
* user: The user to run the service under
* group: The group to run the service under
* java_home: The location of the JRE on the system
* download_url: The fullpath, including the tarball, to the system build
* authentication_url - The base REST url for authentication (Defaults to http://ec2-174-129-84-113.compute-1.amazonaws.com/camservice)
* java_opts - Options to start java (e.g. "-Xms2048m -Djava.net.preferIPv4Stack=true")

= USAGE: