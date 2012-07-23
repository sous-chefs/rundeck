## Future

* Don't give the hadoop user a valid shell / home directory / bashrc
* Format the data disks if they haven't been formated already

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
