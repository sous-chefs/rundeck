Changelog
=========

## 4.2.0
* Add optional LDAP data bag support
* Support Rundeck 2.9.x
* Repoint download location to bintray and enable HTTPS

## 4.1.1
* Fixes symbolic link error when wrapping cookboook #162 

## 4.1.0
* Added support for rundeck version 2.7.x. Backward compatibility for 2.6.x is still there

## 4.0.0
* Project changes
  * Projects are now created _and_ updated according to the data bag definition
  * Create projects with api rather than CLI
  * Project data bag change: projects will now be created / updated with config _exactly_ matching what is in the `"project_settings"` key in the data bag item. If you want to set extra config for all projects, consider adding attributes into `['rundeck']['framework']['properties']`
  * [The functionality to set `resources.source.1` and `project.resources.file` for all projects](https://github.com/Webtrends/rundeck/blob/3865dc95cc3da033a9346680991a5cc29376c2be/recipes/server_install.rb#L270-L277) has been removed because it makes too many assumptions about projects. You can re-enable this functionality on a per-project basis by setting the `"old_style"` key to `true` in the project data bag item. See the lwrp for more information on this.
* Use `['rundeck']['framework']['properties']` to set additional config in the `framework.properties` template

## 3.0.1
* Fixed issue #104 (ACL databag not being handled)
* Support for backward compatibility of Rundeck.

## 3.0.0
* Added LWRP User
* Added LWRP Plugin
* Support ACL policy file data bag
* Support SSL certs via data bag
* Support LDAP bindDn and password via data bag to enable encryption
* Support RDBMS config via data bag to enable encryption
* Add CA certs to Java truststore
* Fix SSL so that CLI works properly and configure SSL offloading to proxy
* Fix issue with server presenting itself on 127.0.0.1

## 2.0.12
* Update template file for 2.6.2
* Update downloaded deb and rpm for 2.6.2
* Updated checksum for 2.6.2
* Alter default loglevel
* Change JVM memory settings to an attribute.
* Change Apache template to work with different auth modules (commonly seen with apache 2.2->2.4)
* winrm plugin broken in 2.6.  Updating winrm plugin to version 1.3.1 from 1.1

##  2.0.11
* upgrading to 2.6.0
* fixing AD auth issues with forcebinding not working correctly

##  2.0.10
* separated out apache, java, and rundeck server install, so you can install your own flavors
* created grails variables so there more control over listening port

## 2.0.7
* Using attributes for databag items
* Bug fixes

## 2.0.6
* updating to rundeck version 2.4.2-1 GA

## 2.0.5
* added more options for LDAP configurations
* improved the install process for the package option
* configurable databag names
* add a users item to rundeck data bag to allow changing of default admin password.  This may be encrypted if needed.
* remove the tie of rundeck username and group
* chef-client v10 treats `platform?` as attribute instead of method in attributes file
* Add supplemental groups to jaas-activedirectory (https://github.com/rundeck/rundeck/issues/590).  This affects default['rundeck']['default_role']
* bump default rundeck version to 2.3.2-1
* configurable server url attributes added
* fixed home dir creation
* berkshelf and cookbook test updates
* fixed platform detection for attributes on rhel and chef 10

## 2.0.4
* updating to rundeck 2.1.2
* removing runit from rundeck::server recipe.  default init scripts work now!
* bug fix issue #6
* removing runit from chef-rundeck recipe.  use upstart
* Berkshelf support added

## 2.0.3
* added support to add custom project properties via the rundeck_project databag
* bug fixes with email settings in framework.properties
* update rundeck 2.0.3
* Added RHEL support (thanks scottymarshall)

## 2.0.2
* add smtp configuration to rundeck-config.properties
* update for chef-rundeck partial searches with chef 11

## 2.0.1
* add support for multiple chef-rundeck URL

## 2.0.0
* update rundeck 2.0.1
* update to chef-rundeck 1.0.2
* added a README.md file
* added a CONTRIBUTING file
* adding Travis-CI integration and foodcritic support

## 1.1.0
* update rundeck from 1.4 to 1.6

## 1.0.11
* Move chef-rundeck URL config into the project data bags for multiple chef-rundeck URLs

## 1.0.10
* Add support for windows via winrm

## 1.0.7
* Add support for sudo cookbook version 2.0+

## 1.0.6
* Add support for relational databases mysql and oracle
* Fixed path issues and updated to latest deb

## 1.0.5
* Address food critic warnings

## 1.0.4
*  Parameterized the rundeck.rb template

## 1.0.1
*  Updating chef-rundeck gem.

## 1.0:

* Initial releas
