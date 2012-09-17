#
# Cookbook Name:: storm
# Recipe:: undeploy
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
#

runit_service "supervisor" do
    action :disable
    run_restart false
end

# try to stop the service, but allow a failure without printing the error
service "supervisor" do
  action [:stop, :disable]
  ignore_failure true
end

# force stop the service in case the stop failed
service "supervisor" do
  action [:stop]
  stop_command "force-stop"
  ignore_failure true
end 

# and just in case that did not work, we do a kill on all storm user processes
execute "kill" do
  user    "root"
  group   "root"
  command "killall -u storm"
end