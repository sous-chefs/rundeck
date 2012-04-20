default[:zookeeper][:version] = "3.3.4"
default[:zookeeper][:sourceURL] = "http://mirror.uoregon.edu/apache/zookeeper/zookeeper-#{node[:zookeeper][:version]}/zookeeper-#{node[:zookeeper][:version]}.tar.gz"

default[:zookeeper][:installDir] = "/opt/zookeeper"
default[:zookeeper][:logDir] = '/var/log/zookeeper'
default[:zookeeper][:dataDir] = "/var/zookeeper"
default[:zookeeper][:snapshotDir] = "#{default[:zookeeper][:dataDir]}/snapshots"

default[:zookeeper][:tickTime] = 2000
default[:zookeeper][:initLimit] = 10
default[:zookeeper][:syncLimit] = 5
default[:zookeeper][:clientPort] = 2181
default[:zookeeper][:snapshotNum] = 3