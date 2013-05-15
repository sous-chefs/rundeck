#
# Cookbook Name:: wt_actioncenter_management_api
# Recipe:: default
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
#


auth_data    = data_bag_item('authorization',node.chef_environment)
ads_host     = URI(node['wt_streamingconfigservice']['config_service_url']).host
ads_ssl_port = node['wt_streamingconfigservice']['config_service_ssl_port']
authToken    = auth_data['wt_streamingconfigservice']['authToken']
kafka_topic  = "#{node['wt_common']['datacenter']}_#{node['wt_common']['pod']}_ActionRoutes"

wt_portfolio_harness_plugin "actioncenter_management_api" do
  download_url node['wt_actioncenter_management_api']['download_url']
  force_deploy true if ENV["deploy_build"] == "true"
  after_deploy Proc.new {    
    #copy messages jar to harness
    #until we solve the class loader issues.
    execute "copy messages" do
      command "cp #{new_resource.install_dir}/lib/action-center-messages*.jar #{node['wt_portfolio_harness']['lib_dir']}/."
      action :run
    end
  }
  
  configure Proc.new {
    template "#{new_resource.conf_dir}/config.properties" do 
      source "config.properties.erb" 
      owner "root" 
      group "root" 
      mode 00644 
      variables({ 
        :ads_host => ads_host,
        :secure_config_host => ads_host,
        :authToken => authToken,
        :secure_config_port => ads_ssl_port,
        :cam_host => node['wt_cam']['cam_service_url'],
        :cam_port => "80",
        :kafka_topic => kafka_topic
      })
    end 
  }
end


