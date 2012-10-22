#
# Cookbook Name:: wt_static_tag_host
# Recipe:: undeploy
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
#

# delete the static tag host files
execute "delete_files" do
   cwd "/var/www"
   command "rm -rf *"
   action :run
   user "root"
   group "root"
end