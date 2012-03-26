Description
===========
Configures squid as a caching proxy.

Recipes
=======
default
-------
The default recipe installs squid and sets up simple proxy caching. As of now, the options you may change are the port (`node['squid']['port']`) and the network the caching proxy is available on the subnet from `node.ipaddress` (ie. "192.168.1.0/24") but may be overridden with `node['squid']['network']`. The size of objects allowed to be stored has been bumped up to allow for caching of installation files.

Usage
=====
Include the squid recipe on the server. Other nodes may search for this node as their caching proxy and use the `node.ipaddress` and `node['squid']['port']` to point at it.

License and Author
==================

Author:: Matt Ray (<matt@opscode.com>)

Copyright 2012 Opscode, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

