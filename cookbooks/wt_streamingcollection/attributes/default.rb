#
# Cookbook Name:: wt_streamingcollection
# Attributes:: default
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
#

default['wt_streamingcollection']['user']         = "webtrends"
default['wt_streamingcollection']['group']        = "webtrends"
default['wt_streamingcollection']['download_url'] = ""
default['wt_streamingcollection']['port']         = 8080
default['wt_streamingcollection']['java_opts']    = "-Xms1024m -Djava.net.preferIPv4Stack=true"
default['wt_streamingcollection']['jmx_port']     = 10000