#
# Author:: Bryan McLellan <btm@loftninjas.org>
# Cookbook Name:: ad-likewise
# Recipe:: default
#
# Copyright 2010, Bryan McLellan
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

if node[:lsb][:codename] == "karmic"
  include_recipe "ad-likewise::source"
elsif node[:lsb][:codename] == "lucid"
  include_recipe "ad-likewise::package"
else
  include_recipe "ad-likewise::package"
end
