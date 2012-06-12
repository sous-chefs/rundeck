#
# Cookbook Name:: wt_monitoring
# Recipe:: ldap_backup
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
#
# This recipe is used to add test traffic to the Optimize opsmon accounts.
# We use this test data to confirm that data processing is functioning as expected.
#

# create the share mount dir
directory "/srv/optimize_backups/" do
	action :create
	owner   user
	group   group
	mode    00755
  not_if {File.exists?("/srv/optimize_backups/")}
end

# mount the NFS mount and add to /etc/fstab
mount "/srv/optimize_backups/" do
	device "lasstore01.netiq.dmz:/ifs/data/optimize_backups_20120611"
	fstype "nfs"
	options "rw"
	action [:mount, :enable]
end