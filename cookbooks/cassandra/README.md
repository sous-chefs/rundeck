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


Recipes
=======

* default - this recipe attempts to install apache-cassandra1 using yum.

Usage
=====

A role that makes use of this cookbook is recommended to have in following runlist:

1. java - for installing Oracle Java
2. cassandra
