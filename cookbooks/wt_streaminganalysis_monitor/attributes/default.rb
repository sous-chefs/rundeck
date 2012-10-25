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
default['wt_streaminganalysis_monitor']['graphite_interval'] = 5
default['wt_streaminganalysis_monitor']['statuslistener_enabled'] = "true"
default['wt_streaminganalysis_monitor']['statuslistener_znode.root'] = "/StormStatus/Lab_H"
default['wt_streaminganalysis_monitor']['metricslistener_enabled'] = "true"
default['wt_streaminganalysis_monitor']['metricslistener_topic'] = "storm-metrics"
default['wt_streaminganalysis_monitor']['stats_interval'] = 30