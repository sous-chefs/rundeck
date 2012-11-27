## 1.0.10
* ini sourcepath(s) now come from array, node['wt_common']['ifr_locations']
* ini allowoutofsync is determined by number of items in node['wt_common']['ifr_locations']

## 1.0.8
* removed wtliveglue.ini
* added service stop to uninstall
* added service start to install

## 1.0.7
* add wtliveglue configuration

## 1.0.6
* moved templates out of deploy section
* added service restart when configs change
* set default source path to nil

## 1.0.0
* Initial cookbook.
