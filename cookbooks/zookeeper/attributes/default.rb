
default[:zookeeper][:version] = "3.3.4"
default[:zookeeper][:install_stage_dir] = "/usr/local/share/zookeeper"



default[:zookeeper][:tickTime] = 2000
default[:zookeeper][:initLimit] = 10
default[:zookeeper][:syncLimit] = 5
default[:zookeeper][:clientPort] = 2181
default[:zookeeper][:dataDir] = "/var/lib/zookeeper"
default[:zookeeper][:snapshotDir] = "/var/lib/zookeeper/snapshots"
default[:zookeeper][:snapshotNum] = 3
default[:zookeeper][:quorum] = ["localhost"]