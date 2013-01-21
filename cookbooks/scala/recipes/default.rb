#
# Cookbook Name:: scala
# Recipe:: default
#
# Author:: Kyle Allan (<kallan@riotgames.com>)
# Copyright (C) 2012, Riot Games
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
#

include_recipe "java"
include_recipe "ark"

ark "scala" do
  url node[:scala][:url]
  checksum node[:scala][:checksum]
  home_dir node[:scala][:home]
  version node[:scala][:version]
  append_env_path true
  action :install
end

template "/etc/profile.d/scala_home.sh" do
  mode 0755
  source "scala_home.sh.erb"
  variables(:scala_home => node[:scala][:home])
end