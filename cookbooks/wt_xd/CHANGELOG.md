## 2.0.1
* Fixed auth data bag typo

## 2.0.0
* Created recipe for installing windows external data components

## 1.0.3
* Adding the ability to adjust mapred.child.hava.opts by conf file

## 1.0.2:
* Fix a bad variable that failed runs

## 1.0.1:
* the path to hbase was corrected in the file hbasetable.py

## 1.0.0:
* Remove the ZooKeeper fallback if search fails
* Food critic warnings addressed

## 0.0.6:
*  adding template changes for max hours processed

## 0.0.5:
* Remove default download URL to the latest in TeamCity
* Reformatting and food critic fixes

## 0.0.4:
* includes fix for adding to jobtracker the mapreduce apps (facebook/twitter)

## 0.0.3:
* fix of ENG392547 around scan timeouts
* also includes twitter fix ENG392552
* also changed the environment.properties file to include a setting for hbase region lease timeouts for scan
* fixed ENG392544:  Retweet Key Metic total is incorrect

# 0.0.2:
* to support facebook adhering to a constant highwater mark and not resetting itself

# 0.0.1:
* initial release
