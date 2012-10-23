#
# Cookbook Name:: wt_monitoring
# Recipe:: storage_metrics
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
#
# This recipe is used to copy bash scripts and setup cron jobs to snmpwalk NAS and SANs then send the results to graphite.
#

#Copy bash scripts used to poll each LB
remote_directory "/opt/webtrends/storage_metrics" do
  source "storage_metrics"
  owner "root"
  group "root"
  mode 00755
  files_mode 00755
end

#Creating cron jobs to run every 5 mins
cron "PDXSTORE06_Metrics" do
  minute "*/5"
  command "/opt/webtrends/storage_metrics/pdxstore06_metrics.sh"
end

