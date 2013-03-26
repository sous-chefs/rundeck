#
# Author:: Josh Behrends (<josh.behrends@webtrends.com>)
# Cookbook Name:: cassandra
# Recipe:: scheduled_repairs
#
# Copyright 2013, Webtrends Inc.
#
# All rights reserved - Do Not Redistribute
#

# search for all cassandra nodes
cassandra_nodes = Array.new
log "Searching for Cassandra nodes"
search(:node, "role:cassandra").each do |n|
    cassandra_nodes << n[:ipaddress]
end

# create a folder to hold our repair script
directory "/opt/webtrends" do
    owner "root"
    group "root"
    mode 00755
    action :create
end

# template the script
template "/opt/webtrends/cassandra_repairs.sh" do
    source "cassandra_repairs.sh.erb"
    variables( :nodes => cassandra_nodes )
    mode 00755
end

# create cron job to run the cassandra repair script
cron "Cassandra_Repairs" do
    minute "1"
    hour "0"
    day "*"
    month "*"
    weekday "0"
    command "/opt/webtrends/cassandra_repairs.sh"
end
