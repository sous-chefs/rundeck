= DESCRIPTION:
Installs Streaming LogReplayer Service

= REQUIREMENTS:
* java
* runit

= ATTRIBUTES:
* user: The user to run the service under
* group: The group to run the service under
* download_url: The fullpath, including the tarball, to the system build
* log_extension: The file extension to read
* delete_logs: Delete logs after processing
* jmx_port: The port to expose JMX metrics on
* log_share_mount: The NFS export path to mount
* share_mount_dir: The local directory to mount the NFS export to

= USAGE:
