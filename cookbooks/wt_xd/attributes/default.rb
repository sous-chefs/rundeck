#
# Cookbook Name:: wt_xd
# Attributes:: default
#
# Copyright 2012, Webtrends Inc.
#
# All rights reserved - Do Not Redistribute
#

default['wt_xd']['download_url'] = ''
default['wt_xd']['log_level']    = 'INFO'
default['wt_xd']['mapred_child_java_opts'] = '-server -Xmx2048m -Djava.net.preferIPv4Stack=true'
