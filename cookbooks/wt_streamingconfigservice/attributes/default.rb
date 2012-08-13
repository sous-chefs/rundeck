#
# Cookbook Name:: wt_streamingconfigservice
# Attributes:: default
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
#

default['wt_streamingconfigservice']['user'] = "webtrends"
default['wt_streamingconfigservice']['group'] = "webtrends"
default['wt_streamingconfigservice']['java_opts'] = "-Xms1024m -Djava.net.preferIPv4Stack=true"