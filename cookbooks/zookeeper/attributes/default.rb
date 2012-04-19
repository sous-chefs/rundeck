default[:zookeeper][:version] = "3.3.4"

default[:zookeeper][:installDir] = "/usr/local/share/zookeeper"
default[:zookeeper][:logDir] = '/var/log/zookeeper'
default[:zookeeper][:dataDir] = "/var/zookeeper"
default[:zookeeper][:snapshotDir] = "/var/lib/zookeeper/snapshots"

default[:zookeeper][:tickTime] = 2000
default[:zookeeper][:initLimit] = 10
default[:zookeeper][:syncLimit] = 5
default[:zookeeper][:clientPort] = 2181
default[:zookeeper][:snapshotNum] = 3
default[:zookeeper][:quorum] = ["localhost"]