#
# Author:: Eric Heydrick (<eric.heydrick@webtrends.com>)
# Cookbook Name:: cobbler
# Attribute:: default
#
# Copyright 2012, Webtrends Inc.
#

# distribute addresses via dhcp with cobbler
default['cobbler']['manage_dhcp'] = 0

# subnets that cobbler manages systems on
default['cobbler']['subnets'] = {}

# once a system has pxe booted disable the flag to PXE boot again
default['cobbler']['pxe_just_once'] = 0

# the version of chef-client to deploy on CentOS systems
default['cobbler']['deploy_chef_version'] = '10.24.0'

# default kickstart metadata
default['cobbler']['ks_meta']['centos-6.2-x86_64']['tree'] = 'http://centos.mirrors.tds.net/pub/linux/centos/6.3/os/x86_64/'
default['cobbler']['ks_meta']['centos-6.4-x86_64']['tree'] = 'http://centos.mirrors.tds.net/pub/linux/centos/6.4/os/x86_64/'

# yum repo where chef package is located
default['cobbler']['yum']['name']        = 'wtlab'
default['cobbler']['yum']['description'] = 'Webtrends Repo'
default['cobbler']['yum']['baseurl']     = 'http://repo.staging.dmz/repo/yum/webtrends'
