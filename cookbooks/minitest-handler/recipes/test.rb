# Cookbook Name:: minitest-handler
# Recipe:: test
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
#

%w{minitest minitest-chef-handler}.each do |gem|
  chef_gem gem do
    action :install
  end
end

install_path = node['minitest-handler']['path']
owner        = node['minitest-handler']['owner']
group        = node['minitest-handler']['group']
type         = node['minitest-handler']['type']

skip         = node['minitest-handler']['skip'] == true ? true : false
deploy       = ENV['deploy_build'] == true ? true : false


require 'minitest-chef-handler'

if deploy && !skip
  log " the deploy_build value is true, copying cookbooks to node."
   
   directory "tests/" do
     owner     user
     group     group
     mode      00755
     recursive true
     action    :create
   end


   cookbook_file "recipe_#{type}.rb" do
     source   "tests/recipe_#{type}.rb"
     cookbook cookbook_name
   end

   chef_handler "MiniTest::Chef::Handler" do
     source "minitest-chef-handler"
     arguments :path => "**/tests/recipe_#{type}.rb"
     action :enable
   end
end
