#
# Cookbook Name:: wt_dataapi
# Attributes:: default
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
#

default['wt_dataapi']['user']           = "webtrends"
default['wt_dataapi']['group']          = "webtrends"
default['wt_dataapi']['download_url']   = ""
default['wt_dataapi']['port']           = 8080
default['wt_dataapi']['java_opts']      = "-Xms2048m -XX:+UseG1GC -Djava.net.preferIPv4Stack=true"
default['wt_dataapi']['jmx_port']       = 9999
default['wt_dataapi']['usagedbserver']  = ""
default['wt_dataapi']['usagedbname']    = "Streaming"
default['wt_dataapi']['usagedbuser']    = ""
default['wt_dataapi']['usagedbpwd']     = ""
default['wt_dataapi']['log_dir']        = "/var/log/webtrends/dataapi"
default['wt_dataapi']['proxy_host']     = ""
default['wt_dataapi']['sauth_version']  = "v1"
