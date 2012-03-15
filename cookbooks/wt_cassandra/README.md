Description
===========

Installs Cassandra.  This cookbook currently does NOT configure Cassandra.  Future versions may do this.

Requirements
============

Platform
--------

* CentOS

Cookbooks
---------

* java

Attributes
==========

* `node['wt_cassandra']['build_uri']` - fallback location of apache-cassandra1 rpm file.

This attribute is not appart of wt_cassandra cookbook, but it's important.

* `node['java']['install_flavor']` - used by java cookbook and must should be set to "oracle"

Recipes
=======

* default - this recipe attempts to install apache-cassandra1 using yum.  If it cannot find apache-cassandra1, then it tries to grab the rpm from `node['wt_cassandra']['build_uri']`.  

Usage
=====

A role that makes use of this cookbook is recommended to have in following runlist:

1. java - for installing Oracle Java
2. wt_cassandra
