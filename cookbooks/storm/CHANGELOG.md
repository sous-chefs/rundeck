## 1.0.19
* Changed the limits.d file to bump the open file limit for any user

## 1.0.18
* Removed Webtrends specific attributes

## 1.0.17
* Change nimbus and storm ui start/stop scripts to kill related
  processes

## 1.0.16
* Increase file limits for the storm user from 1024 to 32k

## 1.0.15
* Someone changes something

## 1.0.14
* Create a link /opt/storm/current that points to the current version

## 1.0.13
* Some Sean changes

## 1.0.12
* added fallback method of getting zookeeper servers from attributes

## 1.0.10
* storm 0.7.2 as default
* storm pulled from internal repo now, no longer stored as a cookbook file

## 1.0.9
* Force install the prereq packages to resolve issues with unsigned packages
* Add every possible attribute ever, but don't use them *yet*

## 1.0.8
* cookbook re-write
* using debs for zeromq and jzmq
