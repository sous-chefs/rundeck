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

# default kickstart metadata by distribution
default['cobbler']['ks_meta']['centos-6.2-x86_64']['tree'] = 'http://centos.mirrors.tds.net/pub/linux/centos/6.3/os/x86_64/'
default['cobbler']['ks_meta']['centos-6.4-x86_64']['tree'] = 'http://centos.mirrors.tds.net/pub/linux/centos/6.4/os/x86_64/'

# version of chef-client to deploy to ubuntu
default['cobbler']['chef_version_ubuntu']['lucid']   = '10.24.0-1.ubuntu.10.04'
default['cobbler']['chef_version_ubuntu']['oneiric'] = '10.24.0-1.ubuntu.11.04'
default['cobbler']['chef_version_ubuntu']['precise'] = '10.24.0-1.ubuntu.11.04'

# apt repo where chef package is located
default['cobbler']['apt']['url'] = 'http://repo.staging.dmz/repo/apt/webtrends'

# version of chef-client to deploy to centos
default['cobbler']['chef_version_centos'] = '10.24.0'

# yum repo where chef package is located
default['cobbler']['yum']['name']        = 'wtlab'
default['cobbler']['yum']['description'] = 'Webtrends Repo'
default['cobbler']['yum']['baseurl']     = 'http://repo.staging.dmz/repo/yum/webtrends'

