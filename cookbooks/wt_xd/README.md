Description
===========
Installs scripts used to create XD hbase tables and installs XD mapreduce jobs

Recipes
======
* `wt_xd::schema` - copies python scripts for creating XD hbase tables.  Requires a server with hbase shell present.

	usage:   ./create_tables.py <dc> <pod>
	example: ./create_tables.py pdx 01

* `wt_xd::mapred` - deploys files and creates cron jobs for XD mapreduce.

Requirements
============

Attributes
==========

* `node['wt_xd']['download_url']` - http location of build
* `node['wt_xd']['log_level']` - log level, used in each log4j config file
* `node['wt_common']['install_dir_linux']` - install directory
* `node['wt_common']['log_dir_linux']` - log directory
* `node['hbase']['data_center_id']` - hbase datacenter id
* `node['hbase']['pod_id']` - hbase pod id
* `node['zookeeper']['quorum']` - list of zookeeper servers
* `node['zookeeper']['client_port']` - zookeeper client port
* `node['java']['java_home']` - java home directory

Usage
=====
* `wt_xd::schema` should be installed on primary name node
* `wt_xd::mapred` map reduce jobs can be deploy on its own server

