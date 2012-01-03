#
# Cookbook Name:: cassandra
# Recipe:: raid
#
# Copyright 2011, DataStax
#
# Apache License
#

###################################################
# 
# Creating RAID0
# Insert optional personalized RAID code here
# 
###################################################

# Quick alternative for EC2
execute "sudo mkdir /mnt2"
execute "sudo mount /dev/sdc /mnt2"
default[:cassandra][:data_dir] = "/mnt"
default[:cassandra][:commitlog_dir] = "/mnt2"

# A typical setup will want the commit log and data to be on two seperate drives.
# Although for EC2, tests have shown that having the commit log and data on 
# the same RAID0 show better performance.

# mdadm "/dev/md0" do
#   devices [ "/dev/sdb", "/dev/sdc" ]
#   level 0
#   chunk 64
#   action [ :create, :assemble ]
# end

# mount "/raid0/" do
#   device "/dev/md0"
#   fstype "ext3"
# end
