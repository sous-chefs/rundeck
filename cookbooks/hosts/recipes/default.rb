#
# Cookbook Name:: hosts
# Recipe:: default
#
# Copyright 2012, Webtrends Inc
#
# All rights reserved - Do Not Redistribute
#

if platform?("centos","rhel","scientific","amazon")
  template "/etc/hosts" do
    source "hosts.erb"
    mode 00644
    owner "root"
    group "root"
  end
end