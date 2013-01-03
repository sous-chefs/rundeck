## 1.1.6
* STR-779 folder permissions bug

## 1.1.5
* Added sms_url to invoke billing usage from CAM plugin

## 1.1.4
* Changed the wt_base icacls call to be directory rights calls

## 1.1.3
* Added share_wrs 

## 1.1.2
* Allowed double escaping for email handling via url

## 1.1.1
* Fixed incorrect assembly name in log4net.config template

## 1.1.0
* Fixed whitespace and typos

## 1.0.32
* Added ruby block to prewarm app pool
## 1.0.31
* Added ui user to the Performance Monitor Users group

## 1.0.30
* Address a food critic warning

## 1.0.29
* Removed remaining references to auth in recipe, attributes and templates
* Updated readme (str-129)

## 1.0.28
* Added template entries for audit logging

## 1.0.27
* Added streams.url variable to the web.config template

## 1.0.26
* Added smtp variable to the web.config template

## 1.0.25
* Added ldap variables to the web.config template

## 1.0.24
* Removed unnecessary pod variable from the plugins recipe
* Fix resource formatting

## 1.0.23
* Added ignore_failures to uninstall.

## 1.0.22
* Set the application pool when creating the site for cam and auth
* Removed DefaultAppPool

## 1.0.21
* Added retries to the site add/start resource for auth

## 1.0.20
* Added retries to the site add/start resource

## 1.0.19
* Address food critic warnings
* Remove CAM Lite cookbooks since we don't use CAM lite anymore

## 1.0.18
* Take out the "latest" builds for download URLs from the default attributes.  This has unintended consequences when a bad attribute is in an environment file

## 1.0.17
* Added the 'cam_plugins' recipe and logic to call it at the end of the default recipe run

## 1.0.16
* Modified attribute names to use 3 parts
* Added templates for log4net to auth and cam

## 1.0.15
* Adding in missing windows_zipfile resource

## 1.0.14
* Reverting port back to 82
* Changed cam_lite_port to camlite_port

## 1.0.13
* Changed CamLite port to 85

## 1.0.12
* Fixed spacing and removed check around firewall rule.

## 1.0.11
* Changed CamLite to use installdir instead of hardcoded path.

## 1.0.10
* Added attributes for the port numbers for cam, auth and cam_lite
* removed hard-coded values for same

## 1.0.9
* Separated Auth service from the Cam
* Updated cam cookbook and web.config template
* Added web.config template for Auth
* Added install and uninstall recipes for Auth

## 1.0.8
* Web.config template again - format of connection string changed

## 1.0.7
* Updated the web.config template with the correct database connection string

## 1.0.6
* Changed the database name to match the db deploy

## 1.0.5
* Added a cam_lite recipe to split the old stuff out. This will eventually go away

## 1.0.4
* removed camdb_user and change web.config to use Trusted_Connection
* changed service account to be ui_user
* gave ui_user modify access to install_dir, so logging can occur
* added db_name attib which defaults to wt_CamLite, but we should use wtCamLite to match systemdb naming convention.
* set CAM site folder to an empty folder at c:\inetpub\wwwroot, only CamService vApp uses install_dir

## 1.0.1:
* Change URL attribute to download_url to match other products

## 1.0.0:
* Initial release
