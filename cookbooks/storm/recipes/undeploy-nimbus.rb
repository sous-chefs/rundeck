#
# Cookbook Name:: storm
# Recipe:: undeploy
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
#

runit_service "nimbus" do
    action :disable
    run_restart false
end

# try to stop the service, but allow a failure without printing the error
service "nimbus" do
  action [:stop, :disable]
  ignore_failure true
end

# force stop the service in case the stop failed
service "nimbus" do
  action [:stop]
  stop_command "force-stop"
  ignore_failure true
end

runit_service "stormui" do
    action :disable
    run_restart false
end

# try to stop the service, but allow a failure without printing the error
service "stormui" do
  action [:stop, :disable]
  ignore_failure true
end

# force stop the service in case the stop failed
service "stormui" do
  action [:stop]
  stop_command "force-stop"
  ignore_failure true
end

# and just in case that did not work, we do a kill on all storm user processes
execute "kill" do
  user    "root"
  group   "root"
  returns [0,1]
  command "killall -u storm"
end