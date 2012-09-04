#
# Cookbook Name: wt_cam_db
# Recipe: default
# Author: Adam Sinnett(<adam.sinnet@webtrends.com>)
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute


auth_data = data_bag_item('authorization', node.chef_environment)
camdbuser = auth_data['wt_streamingconfigservice']['camdbuser']
camdbpwd = auth_data['wt_streamingconfigservice']['camdbpwd']


#Properties
db_name = node['wt_streamingconfigservice']['camdbname']
db_host = node['wt_streamingconfigservice']['camdbserver']
db_port = node['wt_streamingconfigservice']['port']

sql_server_database db_name do
    connection ({:host => db_host,
                 :port => db_port,
                 :username => camdbuser, 
                 :password => camdbpwd})
    action :drop 
end
