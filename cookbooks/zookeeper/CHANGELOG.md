## Future

## 1.0.5:
* exposed jmx port as an attribute

## 1.0.4:
* moved conf files to /etc/zookeeper
* configured log dir to be /var/log/zookeeper
* removed home directory and shell for zookeeper user
* setup service to start up using runit
* attribute names have changed

## 1.0.3:
* Adding jmx to zookeeper

## 1.0.2:
* Write the templates out to the correct directory so the recipe works

## 1.0.1:
* Fix mode declarations to use best practices
* Remove the deletion of the old Zookeeper roller script.  No need for this anymore
* Link from the current version Zookeeper-3.3.4 to a folder named current not /usr/local/zookeeper

## 1.0.0:
* Initial release with a changelog
