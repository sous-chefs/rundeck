#
# Cookbook Name:: wt_streamingauditor
# Attributes:: default
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
#

default['wt_streamingauditor']['user'] = "webtrends"
default['wt_streamingauditor']['group'] = "webtrends"
default['wt_streamingauditor']['download_url'] = ""
default['wt_streamingauditor']['java_opts'] = "-Xms1024m -Djava.net.preferIPv4Stack=true"
default['wt_streamingauditor']['auditlistener_enabled'] = false
default['wt_streamingauditor']['roundtrip_interval'] = 10
default['wt_streamingauditor']['roundtrip_scs_dcsid'] = "dcsi6mqqn00000kb6g4qhxvtt_7t9q"
default['wt_streamingauditor']['roundtrip_tagserver_dcsid'] = "dcsjlcm9a10000wowm5b8svtt_8t7o"
default['wt_streamingauditor']['roundtrip_tagserver_url'] = "http://statse.webtrendslive.com"
default['wt_streamingauditor']['roundtrip_scs_urls'] = "http://scs.webtrends.com,http://scs.pdx.webtrends.com,http://scs.las.webtrends.com,http://scs.iad2.webtrends.com,http://scs.ams.webtrends.com"
default['wt_streamingauditor']['roundtrip_tagserver_timeout'] = 15
default['wt_streamingauditor']['roundtrip_scs_timeout'] = 2
default['wt_streamingauditor']['jmx_port'] = 9999
default['wt_streamingauditor']['sauth_version'] = "v1"
default['wt_streamingauditor']['log_dir'] = "/var/log/webtrends/streamingauditor"
default['wt_streamingauditor']['log_level'] = "WARN"
