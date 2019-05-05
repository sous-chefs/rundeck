# frozen_string_literal: true
#
# Cookbook:: rundeck
# Resource:: cli
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

include RundeckCookbook::Helpers

property :basedir, String, default: '/var/lib/rundeck'
property :url, String, default: 'http://localhost:4440'
property :rundeckgroup, String, default: 'rundeck'
property :rundeckuser, String, default: 'rundeck'
property :admin_password, String, default: 'admin', sensitive: true

action :install do
  package 'rundeck-cli' do
    action :install
  end

  directory "#{new_resource.basedir}/.rd" do
    owner new_resource.rundeckuser
    group new_resource.rundeckgroup
    mode '0700'
    action :create
  end

  template "#{new_resource.basedir}/.rd/rd.conf" do
    cookbook 'rundeck'
    source 'rd.conf.erb'
    owner new_resource.rundeckuser
    group new_resource.rundeckgroup
    sensitive true
    variables(
      rd_url: new_resource.url,
      rd_user: 'admin',
      rd_password: new_resource.admin_password
    )
    action :create
  end
end
