## 1.1.11
* Changing default values for 'sender_max_delay_before_dropping_data_ms' and 'sender_max_send_retries'

## 1.1.10
* Adding typesafe config

## 1.1.9
* Fix for AC-228 : Data Destination Server is uploading event data to Responsys through the proxy

## 1.1.8
* added public certificate

## 1.1.7
* added proxy settings

## 1.1.6
* minor cleanup and fix for incorrect unistall dir

## 1.1.5
* Added missing wt_actioncenter_dd_webtrendsemaildemo parameter to default.rb

## 1.1.4
* Adding default values for parameters

## 1.1.3
* Removing unused undefined parameter

## 1.1.2
* Adding partner plugin specific settings to config file

## 1.1.1
* Using service[restart] vs runit_service

## 1.1.0
* Updated to use new harness structure for install_dir
* Cleaned up properties
* Moved templates outside the deploy gate
* Added notifications to restart the harness service

## 1.0.0
* Initial release
