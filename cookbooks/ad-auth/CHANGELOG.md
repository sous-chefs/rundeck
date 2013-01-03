## 1.0.6
* Add attribute check for setting hostnames with environment prepended for openstack using boolean attribute usenameprefix

## 1.0.5
* Add OS support to the metadata
* Use a standard default.rb attributes file not a non-standard named file

## 1.0.4
* Non-impacting code cleanup to follow best practices
* Remove the apt-get update before installing on 12.04 as that is not necessary
* Remove the force install on 12.04 as that is not necessary

## 1.0.3:
* Broke out Ubuntu 12.04 to it's own recipe. It installs the ubuntu likewise-open package and is not bound to a version.

## 1.0.2:
* Add and apt-get update right before trying to install the package

## 1.0.1:
* Initial release with a changelog
