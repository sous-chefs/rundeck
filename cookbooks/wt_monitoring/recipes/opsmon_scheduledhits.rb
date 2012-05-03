#
# Cookbook Name:: wt_monitoring
# Recipe:: opsmon_scheduledhits
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
#
# This recipe is used to add test traffic to the Optimize opsmon accounts.
# We use this test data to confirm that data processing is functioning as expected.
#

package "curl" do
 action :install
end

cron "opsmon01_scheduledhits" do
  minute "*/5"
  command "/usr/bin/curl -d type=v -d domainID=265528 -d testID=265891 -d runID=265893 -d systemUID=$(date \"+%s\") http://ots.optimize.webtrends.com/ots/ots/json-ping-3.1"
end

cron "opsmon02_scheduledhits" do
  minute "*/5"
  command "/usr/bin/curl -d type=v -d domainID=265613 -d testID=265919 -d runID=265921 -d systemUID=$(date \"+%s\") http://ots.optimize.webtrends.com/ots/ots/json-ping-3.1"
end

cron "opsmon03_scheduledhits" do
  minute "*/5"
  command "/usr/bin/curl -d type=v -d domainID=265700 -d testID=265922 -d runID=265924 -d systemUID=$(date \"+%s\") http://ots.optimize.webtrends.com/ots/ots/json-ping-3.1"
end

cron "opsmon04_scheduledhits" do
  minute "*/5"
  command "/usr/bin/curl -d type=v -d domainID=265800 -d testID=265925 -d runID=265927 -d systemUID=$(date \"+%s\") http://ots.optimize.webtrends.com/ots/ots/json-ping-3.1"
end



