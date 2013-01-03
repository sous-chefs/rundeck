#
# Author:: Kendrick Martin(<kendrick.martin@webtrends.com>)
# Cookbook Name:: geminabox
# Attribute:: default
#
# Copyright 2012, Webtrends Inc.


default['geminabox']['install_dir'] = "/var/geminabox"
default['unicorn']['port'] = 8080
default[:unicorn][:options] = { :tcp_nodelay => true, :backlog => 100 }