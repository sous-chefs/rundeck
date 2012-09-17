#
# Author:: Kendrick Martin <kendrick.martin@webtrends.com>
# Cookbook Name:: chef-server
# Recipe:: config-solr
#
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


template node['solr']['config_path'] do
  owner "chef"
  group "chef"
  variables(
    :maxFieldLength => node['solr']['max_field_size']
  )
  notifies :restart, "service[chef-solr]"
end

service "chef-solr" do
  action :nothing
end