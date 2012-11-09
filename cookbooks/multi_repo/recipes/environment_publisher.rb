#
# Cookbook Name:: multi_repo
# Recipe:: environment_publisher
#
# Copyright 2012, Webtrends, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


# clone the repo to root's home directory if it hasn't been done already
execute "clone_repo" do
  command "git clone #{node['multi_repo']['chef_repo_path']} /srv/chef-repo"
  action :run
  user "root"
  group "root"
  creates "/srv/chef-repo"
end

# link just the environment file to the root of the repository
link "/srv/repo/chef_environments" do
  to "/srv/chef-repo/environments"
  action :create
end

# setup a cron job to keep root's repo up to date by pulling every 30 minutes
cron "update_chef_repo" do
  command "cd /srv/chef-repo; git pull"
  minute "*/30"
end