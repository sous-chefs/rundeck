#!/usr/bin/env bash

COMMAND="java"
if [ "$(whoami)" != "zookeeper" ]
then
	COMMAND="sudo -u zookeeper java"
fi

source /home/zookeeper/.profile

<%= node[:zookeeper][:installDir] %>/zookeeper-<%= node[:zookeeper][:version] %>/bin/zkCleanup.sh  <%= node[:zookeeper][:dataDir] %> <%= node[:zookeeper][:snapshotDir] %> <%= node[:zookeeper][:snapshotNum] %>

exit 0
