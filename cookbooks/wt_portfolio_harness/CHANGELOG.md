## 1.1.5
* Added health check template for Nagios support

## 1.1.4
* Updated the Nagios check to make sure it calls the health check on the main port (i.e. 8080)

## 1.1.3
* Updated authentication section in application.conf

## 1.1.2
* Exposed lib directory for use by plugins to copy jars

## 1.1.1
* Moved service creation before templates
* Split runit service creation and service start into seperate resources
* Added delay to template restarting service

## 1.1.0
* Created plugin directory attribute and set it on the node
* Fixed spacing
* Moved service creation outside deploy gate
* Created loop for directory creation

## 1.0.1
* Changes

## 1.0.0
* Initial release
