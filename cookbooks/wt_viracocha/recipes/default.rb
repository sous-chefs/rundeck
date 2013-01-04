#
# Cookbook Name:: viracocha
# Recipe:: default
#
# Copyright 2012, Webtrends Inc.
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

include_recipe "ruby"
include_recipe "rbvmomi"
include_recipe "build-essential"

%w{ unixodbc-dev freetds-dev freetds-bin ec2-api-tools libxslt-dev libxml2-dev }.each do |pkg|
  package pkg
end

%w{ ruby-odbc dbd-odbc dbi aws aws-s3 trollop highline json nokogiri net-ping json dnsruby}.each do |gem|
  gem_package gem
end

begin
  auth_dbag = data_bag_item('authorization', node['authorization']['ad_likewise']['ad_network'])
rescue
  auth_dbag = data_bag_item('authorization', node['authorization']['ad_auth']['ad_network'])
end

if auth_dbag['ec2'].nil?
  log('No ec2 data in authorization data bag.') { level :warn }
else

  directory "/home/bobo/.ec2/" do
    owner "root"
    group "root"
    mode 00700
    action :create
    recursive true
  end

  template "/home/bobo/.ec2/ec2rc" do
    source "ec2rc.erb"
    owner "root"
    group "root"
    mode 00700
    variables(
      :ec2_access_key => auth_dbag['ec2']['ec2_access_key'],
      :ec2_secret_key => auth_dbag['ec2']['ec2_secret_key']
    )
  end

  file "/home/bobo/.ec2/cert-ZO6RBYVDHGN57LV7N5UGQGQL7IJJEXCH.pem" do
    owner "root"
    group "root"
    mode 00600
    content auth_dbag['ec2']['ec2_cert']
  end

  file "/home/bobo/.ec2/pk-ZO6RBYVDHGN57LV7N5UGQGQL7IJJEXCH.pem" do
    owner "root"
    group "root"
    mode 00600
    content auth_dbag['ec2']['ec2_pk']
  end

  directory "/home/bobo/.ssh" do
    owner "root"
    group "root"
    mode 00600
    action :create
    recursive true
  end

  file "/home/bobo/.ssh/wt-opt-prod" do
    owner "root"
    group "root"
    mode 00600
    content auth_dbag['ec2']['ssh_pk']
  end

  file "/home/bobo/.ssh/wt-opt-prod.pub" do
    owner "root"
    group "root"
    mode 00600
    content auth_dbag['ec2']['ssh_pub']
  end

end
