#
# Cookbook Name:: wt_heatmaps
# Recipe:: import
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
#

# log dir
directory "/home/hadoop/log-drop" do
  owner "hadoop"
  group "hadoop"
  mode 00755
  recursive true
end

# script to import data into hive
cookbook_file "/usr/local/bin/logs2hive.sh" do
  source "import/logs2hive.sh"
  owner "hadoop"
  group "hadoop"
  mode 00500
  recursive true
end

cron "logs2hivecron" do
  command "/usr/local/bin/logs2hive.sh"
  user "hadoop"
end