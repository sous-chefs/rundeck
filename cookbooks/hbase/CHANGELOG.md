## Future

## 1.1.5
* added nrpe check to region server recipe to scan log for exceptions.

## 1.1.4
* added more log messages to search method
* decreased search timeout to 60 seconds

## 1.1.3
* adding ability to turn on hbase replication.  Does not actually turn on replication but gives you the ability to set it up table by table

## 1.1.2
* treat cluster_name 'default' and nil to be the same cluster

## 1.1.1
* node.save at beginning
* changed hbase_search to always return an Array

## 1.1.0
* add support for multiple clusters in the same chef environment
* moved hbase logs to be under /var/log/hbase

## 1.0.7
* Expose all logging levels as attributes
* Added download_url for source tarball

## 1.0.6
* Add ability to override all values in hbase-site.xml

## 1.0.5
* Install to /usr/share/hbase not /usr/local/hbase so that we follow the same path setup as hadoop
* Don't fall back to localhost if searches don't return a Hadoop namenode
* Don't download the hbase tarball into the hadoop install_dir.  Use the Chef cache dir instead

## 1.0.4
* Log to /var/log/hbase

## 1.0.3
* Minor cleanup
* Use the hadoop install_dir attribute not install_stage_dir

## 1.0.2
* Reverted

## 1.0.1:
* Don't set the JAVA_HOME environmental variable since the JAVA cookbook sets this (and does it better)

## 1.0.0:
* Initial release with a changelog
