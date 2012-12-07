## Future

* Don't give the hadoop user a valid shell / home directory / bashrc
* Format the data disks if they haven't been formated already

## 1.1.11
* adding hadoop proxy properties for Oozie


## 1.1.10
* added support for ubuntu packages
* set JAVA_HOME in hadoop-env.sh

## 1.1.9
* adding attributes for mapred-queue-acls.xml

## 1.1.8
* setting JAVA_LIBRARY_PATH so native hadoop and snappy libraries can be used

## 1.1.7
* added additional hbase and hadoop counters to collectd_hadoop_DataNode.conf.erb template
* includes removal of some counters that never log anything, switching some counters to gauges, and adding a couple of replication specific counters

## 1.1.6
* added more log messages to search method
* decreased search timeout to 60 seconds

## 1.1.5
* fixing jobtracker ui 'Dr.Who' errors when viewing tasks

## 1.1.4
* changed search to role instead of roles
* treat cluster_name 'default' and nil to be the same cluster

## 1.1.3
* node.save at beginning
* changed hadoop_search to always return an Array

## 1.1.2
* add attributes: cluster_administrators, job_acl_modify, job_acl_view

## 1.1.1
* added acls_enabled attribute to aid dev environments

## 1.1.0
* add support for multiple clusters in the same chef environment

## 1.0.7
* namenode and jobtracker use non_datanode_local_dir instead of local_dir in order to take different drive configurations into account

## 1.0.6
* Added mapred.submit.replication factor to mapred-site.xml and corresponding attribute.

## 1.0.5
* Create the mapred.exclude file for decommissioning nodes if it doesn't exist on the name node

## 1.0.4
* Change the install_dir attribute form /usr/local/share/hadoop to /usr/share/hadoop where hadoop actually installs.  This is used by hbase/hive and makes for confusing install directories

## 1.0.3
* Change the install_stage_dir attribute to be install_dir
* Add additional comments and fix formatting

## 1.0.2:
* Expose JMX metrics
* Include Collectd plugins for JMX metrics

## 1.0.1:
* Don't set the JAVA_HOME variable since the Java cookbook manages this and keeps it up to date
* Better creation of a nested folder by using the recursive true call

## 1.0.0:
* Initial release with a changelog
