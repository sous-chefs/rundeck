#
# Cookbook Name:: networking_basic
# Recipe:: default
#
# Copyright 2010, fredz
#
# All rights reserved - Do Not Redistribute
#

case node[:platform]
  when "debian", "ubuntu"
    node[:debian][:install_list].each do |pkg|
      package pkg do
        action :install
        ignore_failure true
    end
  end
  when "rhel", "centos"
    node[:redhat][:install_list].each do |pkg|
      package pkg do
        action :install
        ignore_failure true
    end
  end
end
