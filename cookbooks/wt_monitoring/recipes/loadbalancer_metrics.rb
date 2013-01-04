#
# Cookbook Name:: wt_monitoring
# Recipe:: loadbalancer_metrics
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
#
# This recipe is used to copy bash scripts and setup cron jobs to snmpwalk production LB's and send the results to graphite.
#

#Copy bash scripts used to poll each LB
remote_directory "/opt/webtrends/loadbalancer_metrics" do
  source "loadbalancer_metrics"
  owner "root"
  group "root"
  mode 00755
  files_mode 00755
end

#Create a folder to hold our counter values
directory "/var/lib/webtrends/loadbalancer_metrics" do
  owner "root"
  group "root"
  mode 00755
  action :create
end

#Creating cron jobs to run every 5 mins
cron "AMSLBA_Metrics" do
  minute "*/5"
  command "/opt/webtrends/loadbalancer_metrics/snmp-poll_amslba.sh"
end

cron "IADLBB_Metrics" do
  minute "*/5"
  command "/opt/webtrends/loadbalancer_metrics/snmp-poll_iadlbb.sh"
end

cron "LASLBB_Metrics" do
  minute "*/5"
  command "/opt/webtrends/loadbalancer_metrics/snmp-poll_laslbb.sh"
end

cron "PDXLBB_Metrics" do
  minute "*/5"
  command "/opt/webtrends/loadbalancer_metrics/snmp-poll_pdxlbb.sh"
end
