#
# Cookbook Name:: wt_heatmaps
# Attribute:: default
#
# Copyright 2012, Webtrends Inc.
#

# location of the config distributor
default['wt_heatmaps']['config_distrib'] = ""

# heatmaps version
default['wt_heatmaps']['heatmaps_version'] = "0.0.1"

# map reducers
default['wt_heatmaps']['heatmap_reducers'] = -1

# alternate chef environment to search for shared resources
default['wt_heatmaps']['alt_chef_environment'] = ""
