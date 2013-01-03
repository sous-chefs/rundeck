## 1.2.1
* Changing the execute "extract-zookeeper" to have action :nothing
* Adding notify on untarring to the remote_file

## 1.2.0
* zookeeper 3.4.5

## 1.1.7
* Added ulimit to runit script
## 1.1.6
* added more log messages to search method
* decreased search timeout to 60 seconds

## 1.1.5
* Added max client connections to the configuration and set the default
  to 60 to support topologies in pod with only a single zookeeper node.

## 1.1.4
* move node.save out of zookeeper_search and into default recipe

## 1.1.3
* changed search to role instead of roles
* treat cluster_name 'default' and nil to be the same cluster

## 1.1.2
* node.save at beginning
* changed zookeeper_search to always return an Array

## 1.1.1
* fixed corner case when installing a single node cluster that could not find it role
* restart service if /opt/zookeeper/current link changes, such as during an upgrade or downgrade.

## 1.1.0
* add support for multiple clusters in the same chef environment

## 1.0.7
* Address food critic warnings

## 1.0.6
* Install ZooKeeper 3.3.6 by default now

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
