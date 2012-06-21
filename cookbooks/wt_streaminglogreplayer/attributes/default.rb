default['wt_streaminglogreplayer']['user']         = "webtrends"
default['wt_streaminglogreplayer']['group']        = "webtrends"
default['wt_streaminglogreplayer']['download_url'] = "http://teamcity.webtrends.corp/guestAuth/repository/download/bt127/.lastSuccessful/streaminglogreplayer-bin.tar.gz"
 
default['wt_streaminglogreplayer']['dcsid_whitelist']   = ""
default['wt_streaminglogreplayer']['log_extension']     = ".gz"
default['wt_streaminglogreplayer']['log_share_mount']   = ""
default['wt_streaminglogreplayer']['zookeeper_env']     = nil
default['wt_streaminglogreplayer']['share_mount_dir']   = "/srv/logsharedir"
default['wt_streaminglogreplayer']['kafka_topic']       = "rawHits"
default['wt_streaminglogreplayer']['delete_logs']       = "true"
default['wt_streaminglogreplayer']['java_opts']         = "-Xms1024m -Djava.net.preferIPv4Stack=true"
default['wt_streaminglogreplayer']['kafka_broker_list'] = nil
default['wt_streaminglogreplayer']['lock_check_period'] = 15
