## Future
* Unknown
## 1.0.4
* Fixed the creation the bin dir. 

## 1.0.3
* Added logic to prevent kafka from being nuked each time Chef is run. A manual delete of the kafka install folder will trigger a re-deploy.

## 1.0.2
* Set default broker_id to nil and if not set will use the ip address without the '.'
* Set the default broker_host_name to nil and if not set will use the server hostname
* Fixed log4j.properties problems


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