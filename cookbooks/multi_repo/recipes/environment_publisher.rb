#
# Cookbook Name:: multi_repo
# Recipe:: environment_publisher
#
# Copyright 2012, Webtrends Inc.
#
# All rights reserved - Do Not Redistribute
#

# clone the repo to root's home directory if it hasn't been done already
execute "clone_repo" do
  command "git clone #{node['multi_repo']['chef_repo_path']} /root/chef-repo"
  action :run
  user "root"
  group "root"
  creates "/root/chef-repo"
end

# link just the environment file to the root of the repository
link "/root/chef-repo/environments" do
  to "/var/repo/chef_environments"
  action :create
end

# setup a cron job to keep root's repo up to date by pulling every 30 minutes
cron "update_chef_repo" do
  command "cd /root/chef-repo; git pull"
  minute "*/30"
end