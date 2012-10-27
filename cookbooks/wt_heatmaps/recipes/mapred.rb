#
# Cookbook Name:: wt_heatmaps
# Recipe:: mapred
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
#

package "php-cli"

template "/etc/config_distrib" do
  source "config_distrib.erb"
  owner "hadoop"
  group "hadoop"
  mode 00755
end

template "/etc/heatmap_reducers" do
  source "heatmap_reducers.erb"
  owner "hadoop"
  group "hadoop"
  mode 00755
end

remote_directory "/usr/local/mapred" do
  source "mapred"
  owner "hadoop"
  group "hadoop"
  files_owner "hadoop"
  files_group "hadoop"
  files_mode 00744
  mode 00744
end