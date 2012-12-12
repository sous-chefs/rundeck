#
# Cookbook Name:: wt_monitoring
# Recipe:: nagios_metrics
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
#
# This recipe is used to collect email and paging metrics from a nagios server
#

cron "email_metrics" do
  minute "*/30"
  command "cat /var/log/nagios3/nagios.log | grep \"SERVICE NOTIFICATION: shaggy;\" | grep \-P \-o '(\?<=\\[)[0-9]*(\?=\\])' | uniq -c |sed -e 's/^[ \\t]*//' -e 's/^/echo \"#{node['wt_monitoring']['metric_prefix']}.#{node['hostname']}.nagios.alerts.emails /' -e 's/$/\" | nc #{node['wt_monitoring']['graphite_server']} #{node['wt_monitoring']['graphite_port']}/' | sh"
end

cron "pager_metrics" do
  minute "*/30"
  command "cat /var/log/nagios3/nagios.log | grep \"SERVICE NOTIFICATION: noc-pager;\" | grep \-P \-o '(\?<=\\[)[0-9]*(\?=\\])' | uniq -c |sed -e 's/^[ \\t]*//' -e 's/^/echo \"#{node['wt_monitoring']['metric_prefix']}.#{node['hostname']}.nagios.alerts.pages /' -e 's/$/\" | nc #{node['wt_monitoring']['graphite_server']} #{node['wt_monitoring']['graphite_port']}/' | sh"
end