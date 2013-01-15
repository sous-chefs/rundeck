#
# Cookbook Name:: wt_hdfslogdata_producer
# Attributes:: default
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
#


default['wt_hdfslogdata_producer']['user']         = "webtrends"
default['wt_hdfslogdata_producer']['group']        = "webtrends"
default['wt_hdfslogdata_producer']['download_url'] = ""
default['wt_hdfslogdata_producer']['java_opts']    = "-Xms1024m -Djava.net.preferIPv4Stack=true"


# HDFSLogProducer daemon
default['wt_hdfslogdata_producer']['daemon']['topics']                  = ""
default['wt_hdfslogdata_producer']['daemon']['threads_per_topic']       = "1"
default['wt_hdfslogdata_producer']['daemon']['compression_buffer_size'] = "524288"
default['wt_hdfslogdata_producer']['daemon']['max_log_size']            = "134217728"
default['wt_hdfslogdata_producer']['daemon']['log_path']                = "/tmp"
default['wt_hdfslogdata_producer']['daemon']['completed_log_path']      = "/tmp/finished"
default['wt_hdfslogdata_producer']['daemon']['whitelist']               = ""

#dcs augmentation 
default['wt_hdfslogdata_producer']['dcs']['url']               		= "http://hconfigsvc.staging.dmz/dcsid"


# kafka
default['wt_hdfslogdata_producer']['kafka']['connectiontimeout_ms'] 	= "1000000"
default['wt_hdfslogdata_producer']['kafka']['fetch_size']           	= "3603150"


# GEO augmentation
default['wt_hdfslogdata_producer']['geo']['timeout'] = 400
default['wt_hdfslogdata_producer']['geo']['url'] 			= "hutil01.staging.dmz"


# BZip2 blocksize (1 = 100k)
default['wt_hdfslogdata_producer']['bzip2']['block_size'] 		= 1
default['wt_hdfslogdata_producer']['jmx_port']         			= 9998
default['wt_hdfslogdata_producer']['log4j_logging_level']               = "INFO"

