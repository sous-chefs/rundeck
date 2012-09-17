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