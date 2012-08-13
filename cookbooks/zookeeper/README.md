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

* `node['zookeeper']['version']` - ZooKeeper version.
* `node['zookeeper']['download_url']` - Full url to the tar ball.

* `node['zookeeper']['install_dir']` - ZooKeeper runtime files directory.
* `node['zookeeper']['config_dir']` - ZooKeeper configuration files directory.
* `node['zookeeper']['log_dir']` - Log directory.
* `node['zookeeper']['data_dir']` - Data directory.
* `node['zookeeper']['snapshot_dir']` - Snapshot directory.

* `node['zookeeper']['tick_time']` - The number of milliseconds of each tick.
* `node['zookeeper']['init_limit']` - The number of ticks that the initial synchronization phase can take.
* `node['zookeeper']['sync_limit']` - The number of ticks that can pass between sending a request and getting an acknowledgement.
* `node['zookeeper']['client_port']` - The port at which the clients will connect.
* `node['zookeeper']['snapshot_num']` - The number of snapshots to retain in data directory.

Usage
=====

