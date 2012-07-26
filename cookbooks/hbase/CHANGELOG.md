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
