default['wt_mirrormaker']['user']         = "kafka"
default['wt_mirrormaker']['group']        = "kafka"
default['wt_mirrormaker']['java_opts']    = "-Xms1024m -Djava.net.preferIPv4Stack=true"

default['wt_mirrormaker']['src_envs'] = ["H"]
default['wt_mirrormaker']['topic_white_list'] = "*RawHits"

