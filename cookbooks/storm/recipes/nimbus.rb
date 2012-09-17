#
# Cookbook Name:: storm
# Recipe:: default
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
#

include_recipe "storm"

java_home = node['java']['java_home']
install_dir = "#{node['storm']['install_dir']}/storm-#{node['storm']['version']}"

if ENV["deploy_build"] == "true" then
  log "The deploy_build value is true so un-deploy first"
  include_recipe "storm::undeploy-nimbus"
end

%w{nimbus stormui}.each do |daemon|
  # control file
  template "#{install_dir}/bin/#{daemon}-control" do
    source  "#{daemon}-control.erb"
    owner "root"
    group "root"
    mode  00755
    variables({
      :install_dir => install_dir,
      :log_dir => node['storm']['log_dir'],
      :java_home => java_home
    })
  end
  
  # runit service
  runit_service daemon do
    options({
      :install_dir => install_dir,
      :log_dir => node['storm']['log_dir'],
      :user => "storm"
    }) 
  end
end


