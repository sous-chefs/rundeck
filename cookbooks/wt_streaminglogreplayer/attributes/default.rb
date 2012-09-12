#
# Cookbook Name:: wt_streaminglogreplayer
# Attribute:: default
#
# Copyright 2012, Webtrends Inc.
#

default['wt_streaminglogreplayer']['user']         = "webtrends"
default['wt_streaminglogreplayer']['group']        = "webtrends"
default['wt_streaminglogreplayer']['download_url'] = ""

default['wt_streaminglogreplayer']['log_extension']     = ".gz"
default['wt_streaminglogreplayer']['log_share_mount']   = ""
default['wt_streaminglogreplayer']['share_mount_dir']   = "/srv/logsharedir"
default['wt_streaminglogreplayer']['delete_logs']       = "true"
default['wt_streaminglogreplayer']['java_opts']         = "-Xms1024m -Djava.net.preferIPv4Stack=true"
default['wt_streaminglogreplayer']['kafka_broker_list'] = nil
default['wt_streaminglogreplayer']['lock_check_period'] = 15
default['wt_streaminglogreplayer']['thread_pool_size'] = 100
default['wt_streaminglogreplayer']['logtime_catchup'] = 200
default['wt_streaminglogreplayer']['eventtime_log_regex'] = "^.*(\\d{4}-\\d{2}-\\d{2}-\\d{2}-0\\d{4}).*$"
default['wt_streaminglogreplayer']['znode_root'] = "/LogReplayer"
default['wt_streaminglogreplayer']['jmx_port'] = 9999

# optionally specify the environment where ZooKeeper nodes are located
default['wt_streaminglogreplayer']['zookeeper_env']     = nil