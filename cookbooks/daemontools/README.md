Description
===========

Installs [DJB's Daemontools](http://cr.yp.to/daemontools.html) and
includes a service LWRP.

Requirements
============

## Platform:

Tested on:

* Debian 5.0 and 6.0
* Ubuntu 10.04 and 12.04
* ArchLinux

May work on other platforms with or without modification using the
"source" installation method.

## Cookbooks:

* ucspi-tcp
* pacman (for ArchLinux)
* build-essential (for source installs)

Attributes
==========

* `node['daemontools']['bin_dir']` - Sets the location of the binaries
  for daemontools, default is selected by platform, or
  '/usr/local/bin' as a fallback.
* `node['daemontools']['service_dir']` - Daemontools "service"
  directory where svscan will find services to manage.
* `node['daemontools']['install_method']` - how to install
  daemontools, can be `source`, `package` or `aur` (for ArchLinux).

Recipes
=======

## default

The default recipe dispatches to the other recipes depending on the `node['daemontools']['install_method']`.

## package

Works and tested on Debian family (`platform_family`) for installing the
`daemontools-run` package. This recipe can be included anywhere if you
have a `daemontools` package available in your distribution's package
repositories or in a local package repository.

## aur

On ArchLinux systems, include the pacman cookbook in a base role or
similar as this cookbook doesn't directly depend on it.

## source

The source installation of daemontools should work on most other
platforms that do not have a package available.

Resource/Provider
=================

This cookbook includes an LWRP, `daemontools_service`, for managing
services with daemontools. Examples:

    daemontools_service "tinydns-internal" do
      directory "/etc/djbdns/tinydns-internal"
      template false
      action [:enable,:start]
    end

    daemontools_service "chef-client" do
      directory "/etc/sv/chef-client"
      template "chef-client"
      action [:enable,:start]
      log true
    end

Daemontools itself can perform a number of actions on services. The
following are commands sent via the `svc` program. See its man page
for more information.

* start, stop, status, restart, up, down, once, pause, cont, hup,
  alrm, int, term, kill

Enabling a service (`:enable` action) is done by setting up the
directory located by the `directory` resource attribute. The following
are set up:

* `run` script that runs the service startup using the `template`
  resource attribute name.
* `log/run` directory and script that runs the logger if the resource
  attribute `log` is true.
* `finish` script, if specified using the `finish` resource attribute
* `env` directory, containing ENV variablesif specified with the `env`
  resource attribute
* links the `node['daemontools']['service_dir']/service_name` to the
  `service_name` directory.

The default action is `:start` - once enabled daemontools services are
started by svscan anyway.

The name attribute for the resource is `service_name`.

Usage
=====

Include the daemontools recipe on nodes that should have daemontools
installed for managing services. Use the `daemontools_service` LWRP
for any services that should be managed by daemontools. In your
cookbooks where `daemontools_service` is used, create the appropriate
run and log-run scripts for your service. For example if the service
is "flowers":

    daemontools_service "flowers" do
      directory "/etc/sv/flowers"
      template "flowers"
      action [:enable, :start]
      log true
    end

Create these templates in your cookbook:

* `templates/default/sv-flowers-run.erb`
* `templates/default/sv-flowers-log-run.erb`

If your service also has a finish script, set the resource attribute
`finish` to true and create `sv-flowers-finish.erb`.

The content of the scripts should be appropriate for the "flowers"
service.

License and Author
==================

Author: Joshua Timberman (<joshua@opscode.com>)

Copyright 2010-2012, Opscode, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
