#
# Cookbook Name:: wt_heatmaps_logconverter
# Attributes:: default
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
#

default['wt_heatmaps_logconverter']['user']         = "webtrends"
default['wt_heatmaps_logconverter']['group']        = "webtrends"
default['wt_heatmaps_logconverter']['download_url'] = ""
default['wt_heatmaps_logconverter']['java_opts']    = "-Xms1G -Xmx4G"
default['wt_heatmaps_logconverter']['jmx_port']     = 9999


default['wt_heatmaps_logconverter']['log_level'] = "WARN"
default['wt_heatmaps_logconverter']['nfs_export'] = ""
default['wt_heatmaps_logconverter']['dcsidWhiteList'] = ""
default['wt_heatmaps_logconverter']['nfs_mount_dir'] = "/srv/heatmaps_logconverter/"
default['wt_heatmaps_logconverter']['deleteLogs'] = "true"
default['wt_heatmaps_logconverter']['aggregateSmallFileRollSize'] = 64
default['wt_heatmaps_logconverter']['minimumFileSize'] = 64
default['wt_heatmaps_logconverter']['initialMergerDelay'] = 60
default['wt_heatmaps_logconverter']['mergerInterval'] = 60
default['wt_heatmaps_logconverter']['smallFileWaitTimeMinutes'] = 60