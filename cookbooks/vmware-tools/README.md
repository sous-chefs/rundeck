Description
===========

Installs and configures vmware-tools using the tarball package that
comes on the vmware ESX installation DVD. 

This cookbook works quite differently from the yumrepo::vwmare-tools
recipe which installs rpms from vmware's public repository. 


Platform
--------

* RHEL, CentOS, Fedora
* Debian, Ubuntu theoretically

Tested on RHEL 5 and RHEL 6


Attributes
==========

default
-------

* node['esx']['version'] - version of ESX, this is automatically
detected the default recipe but can be overriden
* node['esx']['tarball'] - name of tarball
* node['esx']['checksum'] - checksum for tarball


Recipes
=======

default
-------

This recipe requires that the attribute be set
node['repo']['corp']['url']. The relevant tarball must located at the
base of that path, for example:

http://repo.example.com/VMwareTools-4.0.0-208167.tar.gz

This value is best set in a role or in the node attributes.


License and Author
==================

Author:: Bryan W. Berry <bryan.berry@gmail.com>

Copyright 2009-2011, Bryan W. Berry

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.


