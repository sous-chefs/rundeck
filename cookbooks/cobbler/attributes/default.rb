#
# Author:: Eric Heydrick (<eric.heydrick@webtrends.com>)
# Cookbook Name:: cobbler
# Attribute:: default
#
# Copyright 2012, Webtrends Inc.
#

# distribute addresses via dhcp with cobbler
default[:cobbler][:manage_dhcp] = 0

# subnets that cobbler manages systems on
default[:cobbler][:subnets] = {}


# once a system has pxe booted disable the flag to PXE boot again
default[:cobbler][:pxe_just_once] = 0

# the version of chef-client to deploy on CentOS systems
default[:cobbler][:deploy_chef_version] = "10.14.4"