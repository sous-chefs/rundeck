#
# Cookbook Name:: wt_opt_hornetq
# Attributes:: default
#
# Copyright 2012, Webtrends, Inc.
#
# All rights reserved - Do Not Redistribute
#

default['hornetq']['download_url'] = ""
default['hornetq']['hornetq_version'] = "hornetq-2.2.5"
default['hornetq']['type'] = "main"
default['hornetq']['jboss_gid'] = 1001
default['hornetq']['jboss_uid'] = 1001
default['hornetq']['pods'] = {}