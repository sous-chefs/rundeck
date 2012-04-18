#!/usr/bin/env bash

COMMAND="java"
if [ "$(whoami)" != "zookeeper" ]
then
	COMMAND="sudo -u zookeeper java"
fi

source /home/zookeeper/.profile

cd /usr/local/zookeeper

$COMMAND -cp zookeeper-3.3.4.jar:lib/log4j-1.2.15.jar:conf org.apache.zookeeper.server.PurgeTxnLog <%= node[:zookeeper][:dataDir] %> <%= node[:zookeeper][:snapshotDir] %> <%= node[:zookeeper][:snapshotNum] %>

exit 0
