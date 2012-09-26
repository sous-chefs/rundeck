Description
===========

Installs and manages the unbound DNS server.

* http://unbound.net

Requirements
============

A platform with unbound available as a native package. The following platforms have unbound packaged, but note that the filesystem locations are not consistent and at this time only Linux + FHS is supported. See the __Attributes__ section.

* Ubuntu/Debian
* Red Hat/CentOS/Fedora (requires EPEL)
* ArchLinux
* FreeBSD

OpenSUSE seems to have removed the unbound package from recent versions, though 1.0.0 was in 11.1.

Attributes
==========

For information about attributes, see the cookbook metadata. Either view the metadata.rb in the cookbook, or review from the Chef server.

    knife cookbook show unbound VERSION

Some values are calculated in the attributes file or in the respective recipes.

Resources
=========

TODO:

Not yet supported.

This cookbook will provide `unbound_rr`, a resource for managing resource records through unbound-control(8) command in the future. This will require that `node['unbound']['remote_control']['enable']` is true.

Templates
=========

For configuration not handled by the template and cookbook attribute values, edit the template for the local environment.

unbound.conf
------------

The main configuration file for unbound. Many settings in the template are controlled via attribute values. The file is located in the `node['unbound']['directory']`.

The config file created by this cookbook will use unbound's `include` directive for zone files, which will be located in the `node['unbound']['directory']`'s `conf.d` directory.

local-zone.conf
---------------

Set up local network resolver configuration with local-zone.conf.

stub-zone.conf
---------------

Edit the stub-zone.erb template to create a stub zone configuration.

forward-zone.conf
-----------------

Edit the forward-zone.erb template to create a forward zone configuration.

remote-control.conf
-------------------

TODO:

Not yet supported.

Sets up the remote-control settings via the `unbound::remote-control` recipe.

Recipes
=======

default
-------

Installs unbound and sets up the configuration file(s).

The recipe will load the local zone data from a data bag if present, otherwise it will attempt to use `node['dns']['domain']` attribute. The various templates can be edited as required by the local user.

chroot
------

The intention of this recipe will be to setup the chroot environment if the chroot setting is enabled. However it is not yet complete.

`remote_control`
----------------

TODO:

Not yet supported.

Sets up remote control certificate attributes using the unbound configuration directory. Also creates the config file for remote-control settings and creates the certificates with unbound-control-setup.

Usage
=====

Create a role for the unbound server like this:

    name "unbound"
    description "DNS Server"
    default_attributes(
      "dns" => {
        "domain" => "int.example.com"
      },
      "unbound" => {
        "access_control" => { "127.0.0.1/8" => "allow", "0.0.0.0/0" => "allow" }
      }
    )
    run_list( "recipe[unbound]")

The `node['dns']['domain']` is used to select the data bag (if it exists), or can be a hash of local zone domain attributes. If using a data bag, it should have the following basic structure.

    {
      "id": "int_example_com",
      "ns": [
        { "int.example.com": "127.0.0.1" }
      ],
      "host": [
        { "www.int.example.com": "10.1.1.200" }
      ]
    }

Unbound itself doesn't support CNAME records. To use this as attributes on the node, put this in the default attributes section of the role (per above).

    default_attributes(
      "unbound" => {
        "id" => "int_example_com",
        "ns" => [
          { "int.example.com" => "127.0.0.1" }
        ],
        "host" => [
          { "www.int.example.com" => "10.1.1.200" }
        ]
      }
    )

* Note: This is untested with node attributes

Chroot
------

TODO:

Not yet fully implemented.

Access Control
--------------

Set the `node['unbound']['access_control']` attribute as a hash in the role to specify the netblock and action.

Remote Control
--------------

TODO:

Not yet supported.

License and Author
==================

Copyright 2011, Joshua Timberman (<cookbooks@housepub.org>)

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
