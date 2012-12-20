Description
===========

Installs ZooKeeper on Ubuntu / Debian systems

Requirements
============
* Ubuntu / Debian system
* java cookbook
* runit cookbook

Attributes
==========

* `node['zookeeper']['cluster_name'] - cluster name, used to find attributes and nodes of same cluster.

* `node['zookeeper']['default']['version']` - ZooKeeper version.
* `node['zookeeper']['default']['download_url']` - Full url to the tar ball.

* `node['zookeeper']['default']['install_dir']` - ZooKeeper runtime files directory.
* `node['zookeeper']['default']['config_dir']` - ZooKeeper configuration files directory.
* `node['zookeeper']['default']['log_dir']` - Log directory.
* `node['zookeeper']['default']['data_dir']` - Data directory.
* `node['zookeeper']['default']['data_log_dir']` - Snapshot directory.

* `node['zookeeper']['default']['tick_time']` - The number of milliseconds of each tick.
* `node['zookeeper']['default']['init_limit']` - The number of ticks that the initial synchronization phase can take.
* `node['zookeeper']['default']['sync_limit']` - The number of ticks that can pass between sending a request and getting an acknowledgement.
* `node['zookeeper']['default']['client_port']` - The port at which the clients will connect.
* `node['zookeeper']['default']['snapshot_num']` - The number of snapshots to retain in data directory.

Usage
=====

