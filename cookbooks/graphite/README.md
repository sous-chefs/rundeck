Description
===========

Installs and configures Graphite http://graphite.wikidot.com/
Has been updated to install Graphite 0.9.10

Requirements
============

* Ubuntu 10.04 (Lucid)
* CentOS 6.2

Attributes
==========

* `node[:graphite][:password]` sets the default password for graphite "root" user.

Usage
=====

`recipe[graphite]` should build a stand-alone Graphite installation.

Caveats
=======

Ships with two default schemas, stats.* (for Etsy's statsd) and a
catchall that matches anything. The catchall retains minutely data for
13 months, as in the default config. stats retains data every 10 seconds
for 6 hours, every minute for a week, and every 10 minutes for 5 years.
