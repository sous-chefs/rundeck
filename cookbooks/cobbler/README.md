Description
===========
This is a cookbook for managing Cobbler with Chef. 

Reqirements
===========

## Platform: 

* Ubuntu/Debian

Recipes
=======

default
-------

The default recipe will install the Cobbler package and setup a default configuration.

Attributes
==========

Node attributes are set under the `cobbler` namespace.

* manage_dhcp - set true to enable Cobbler management of DHCP service
* pxe_just_once - set true disable PXE booting after install
* subnets - array of networks served by DHCP. 

Usage
=====

Add the cobbler recipe to the node's run list. If you want Cobbler to
manage your DHCP service add the following to your environment (or
directly on the node):

    "cobbler": {
      "subnets": {
        "192.168.1.0": {
          "netmask": "255.255.255.0"
        }
      },
      "manage_dhcp": 1,
      "pxe_just_once": 1
    }

License and Author
==================

Author:: Eric Heydrick <eheydrick@gmail.com>
Author:: Tim Smith <tsmith84@gmail.com>

Copyright:: 2011 Eric Heydrick
Copyright:: 2012 Tim Smith

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
