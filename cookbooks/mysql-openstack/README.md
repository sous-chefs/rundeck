Description
===========

The OpenStack recipes depend on osops-utils helper methods for defining access endpoints. This wrapper cookbook configures the required scaffolding for the mysql cookbook.

Requirements
============

Chef 0.10.0 or higher required (for Chef environment use).

Platforms
--------

* Ubuntu-12.04
* Fedora-17

Cookbooks
---------

The following cookbooks are dependencies:

* [mysql](https://github.com/opscode-cookbooks/mysql)
* [osops-utils](https://github.com/mattray/osops-utils)

Resources/Providers
===================

None


Recipes
=======

default
----
- Includes recipe `mysql::server`

Attributes
==========

* `mysql['services']['db']['scheme']` - communication scheme
* `mysql['services']['db']['port']` - Port on which mysql listens
* `mysql['services']['db']['network']`


Templates
=========

None

License and Author
==================

Author:: Justin Shepherd (<justin.shepherd@rackspace.com>)
Author:: Jason Cannavale (<jason.cannavale@rackspace.com>)
Author:: Ron Pedde (<ron.pedde@rackspace.com>)
Author:: Joseph Breu (<joseph.breu@rackspace.com>)
Author:: William Kelly (<william.kelly@rackspace.com>)
Author:: Darren Birkett (<darren.birkett@rackspace.co.uk>)
Author:: Evan Callicoat (<evan.callicoat@rackspace.com>)
Author:: Matt Ray (<matt@opscode.com>)

Copyright 2012, Rackspace US, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
