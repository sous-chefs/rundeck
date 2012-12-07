Description
===========

This cookbook installs the OpenStack Dashboard service **Horizon** as part of the OpenStack **Essex** reference deployment Chef for OpenStack. The http://github.com/opscode/openstack-chef-repo contains documentation for using this cookbook in the context of a full OpenStack deployment. Horizon is installed from packages.

http://nova.openstack.org

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

* apache2
* database
* mysql
* osops-utils

Recipes
=======

default
----
-includes recipe `server`

server
----
-includes recipes `apache2`, `apache2:mod_wsgi`, `apache2:mod_rewrite`, `apache2:mod_ssl`, `mysql:client`
-installs and configures the openstack dashboard package, sets up the horizon database schema/user, and installs an appropriate apache config/site file
-uses chef search to discover details of where the database (default mysql) and keystone api are installed so we don't need to explicitly set them in our attributes file for this cookbook


Attributes
==========
* `horizon["db"]["name"]` - name of horizon database
* `horizon["db"]["username"]` - username for horizon database access
* `horizon["db"]["password"]` - password for horizon database access

* `horizon["use_ssl"]` - toggle for using ssl with dashboard (default true)
* `horizon["ssl"]["dir"]` - directory where ssl certs are stored on this system
* `horizon["ssl"]["cert"]` - name to use when creating the ssl certificate
* `horizon["ssl"]["key"]` - name to use when creating the ssl key

* `horizon["dash_path"]` - base path for dashboard files (document root)
* `horizon["wsgi_path"]` - path for wsgi dir

Templates
=====

* `dash-site.erb` - the apache config file for the dashboard vhost
* `local_settings.py.erb` - config file for the dashboard application


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
Copyright 2012, Opscode, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
