#
# Cookbook Name:: storm
# Recipe:: default
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
#

include_recipe "storm"

install_dir = "#{node['storm']['install_dir']}/storm-#{node['storm']['version']}"

%w{nimbus stormui}.each do |daemon|
  # control file
  template "#{install_dir}/bin/#{daemon}-control" do
    source  "#{daemon}-control"
    owner "root"
    group "root"
    mode  00755
    variables({
      :install_dir => install_dir,
      :log_dir => node['storm']['logdir']
    })
  end
  
  # runit service
  runit_service daemon do
    options({
      :install_dir => install_dir,
      :log_dir => node['storm']['logdir'],
      :user => "storm"
    }) 
  end
end


