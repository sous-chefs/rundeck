#
# Cookbook Name:: wt_monitoring
# Recipe:: email_heartbeat
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
#
# This recipe is used to send a heartbeat e-mail to the admin e-mail address every 4 hours
#

cron "email_heartbeat" do
  hour "*/6"
  command "echo \"At the tone the time will be $(date \\+\\%k:\\%M) on $(date \\+\\%Y-\\%m-\\%d)\" | /bin/mail -s \"Nagios 4hr Heartbeat - $(date \\+\\%k:\\%M)\" #{node['wt_common']['admin_email']}"
end