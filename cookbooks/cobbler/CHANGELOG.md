## 1.0.8
* Use our internal mirrors for security updates during the install

## 1.0.7:
* Added DBAN-2.2.6 profile

## 1.0.6:
* Take out the check to see if running on Chef 0.9.X

## 1.0.5:
* Ensure ruby is installed on CentOS

## 1.0.4:
* Update the precise partition snippet to create a 1024MB swap and use the rest for /

## 1.0.3:
* Switch to gems to install Chef on CentOS
* Allow controlling the version of Chef to install (with Gems) via a new deploy_chef_version attribute

## 1.0.2:
* Modify the partitioning setup based on Webtrends standards for Ubuntu Precise

## 1.0.1:
* Appamor doesn't need to be disabled in precise.
* Fixed ubuntu_netcfg to use correct netmask variable.
* Minor update to settings file to match current release, v2.2.2.
* Added englab to *_apt_repo snippets.
* Made validation.pem readable so it can be freely downloaded.

## 1.0.0:
* Initial release with a changelog.
