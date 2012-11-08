#
# Cookbook Name:: wt_streaminganalysis_monitor
# Attributes:: default
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
#

default['wt_streaminganalysis_monitor']['user']         = "webtrends"
default['wt_streaminganalysis_monitor']['group']        = "webtrends"
default['wt_streaminganalysis_monitor']['download_url'] = ""
default['wt_streaminganalysis_monitor']['java_opts']    = "-Djava.net.preferIPv4Stack=true"
default['wt_streaminganalysis_monitor']['jmx_port']     = 9999
default['wt_streaminganalysis_monitor']['graphite_enabled'] = "true"
default['wt_streaminganalysis_monitor']['graphite_interval'] = 1
default['wt_streaminganalysis_monitor']['statuslistener_enabled'] = "true"
default['wt_streaminganalysis_monitor']['statuslistener_znode_root'] = "/StormStatus"
default['wt_streaminganalysis_monitor']['metricslistener_enabled'] = "true"
default['wt_streaminganalysis_monitor']['metricslistener_topic'] = "storm-metrics"
default['wt_streaminganalysis_monitor']['stats_interval'] = 10
default['wt_streaminganalysis_monitor']['stats_graphite_regex'] = ".*ten_minutes\..*"
default['wt_streaminganalysis_monitor']['healthcheck_enabled'] = "true"
default['wt_streaminganalysis_monitor']['healthcheck_port'] = 9000
default['wt_streaminganalysis_monitor']['cluster_role'] = "wt_storm_streaming_topo"
