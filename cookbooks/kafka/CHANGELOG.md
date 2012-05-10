## Future

* Unknown

## 1.0.1

* Use /opt/kafka as the default intall dir
* Use /var/kafka as the default data dir
* Remove the unnecessary platform case statement from the attributes file
* Remove the attributes for user/group. Always run as kafka user/group
* Remove tarball from the cookbook
* Don't give kafka user a home directory or a valid shell
* Fix runit script to work
* Pull the source file down from a remote URL and not the cookbook
* Use more restrictive permissions on config files
* Use remote zookeeper nodes
* Don't hardcode the broker ID

## 1.0.0
* Initial release with a changelog