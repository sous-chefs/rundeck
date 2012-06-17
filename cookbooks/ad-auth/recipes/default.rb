#
# Cookbook Name:: ad-auth
# Recipe:: default
# Author:: David Dvorak <david.dvorak@webtrends.com>
#
# Based on the ad-likewise cookbook: Copyright 2010, Bryan McLellan
# Copyright 2012, Tim Smith and Peter Crossly
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

if node.platform == "ubuntu" and node.platform_version.to_i >= 12
	include_recipe "ad-auth::ubuntu-12.04"
else
	include_recipe "ad-auth::linux"
end