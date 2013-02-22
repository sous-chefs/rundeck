#
# Cookbook Name:: splunk
# Recipe:: pulse-app
# 
# Copyright 2011-2012, BBY Solutions, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

splunk_app_install "Installing Pulse for AWS Cloudwatch" do
   action                  [:create_if_missing]
   app_file                node['splunk']['pulse_app_file']
   app_version             node['splunk']['pulse_app_version']
   remove_dir_on_upgrade   "true"
end

remote_file "Grabbing boto-#{node['splunk']['boto_version']}.tar.gz" do
   source "#{node['splunk']['boto_remote_location']}/boto-#{node['splunk']['boto_version']}.tar.gz"
   path "#{node['splunk']['server_home']}/etc/apps/pulse_for_aws_cloudwatch/pymodules/boto-#{node['splunk']['boto_version']}.tar.gz"
   action [:create_if_missing]
end

remote_file "Grabbing python-dateutil-#{node['splunk']['dateutil_version']}.tar.gz" do 
   source "#{node['splunk']['dateutil_remote_location']}/python-dateutil-#{node['splunk']['dateutil_version']}.tar.gz"
   path "#{node['splunk']['server_home']}/etc/apps/pulse_for_aws_cloudwatch/pymodules/python-dateutil-#{node['splunk']['dateutil_version']}.tar.gz"
   action [:create_if_missing]
end

if !File.directory?("#{node['splunk']['server_home']}/etc/apps/pulse_for_aws_cloudwatch/bin/boto") 

  execute "Extracting boto-#{node['splunk']['boto_version']}.tar.gz" do
    command "tar zxvf #{node['splunk']['server_home']}/etc/apps/pulse_for_aws_cloudwatch/pymodules/boto-#{node['splunk']['boto_version']}.tar.gz"
    cwd "#{node['splunk']['server_home']}/etc/apps/pulse_for_aws_cloudwatch/pymodules"
  end

  link "Linking boto to pulse_for_aws_cloudwatch/bin" do
    to "#{node['splunk']['server_home']}/etc/apps/pulse_for_aws_cloudwatch/pymodules/boto-#{node['splunk']['boto_version']}/boto"
    target_file "#{node['splunk']['server_home']}/etc/apps/pulse_for_aws_cloudwatch/bin/boto"
  end
 
end

if !File.directory?("#{node['splunk']['server_home']}/etc/apps/pulse_for_aws_cloudwatch/bin/dateutil") 

  execute "Extracting dateutil-1.5.tar.gz" do
    command "tar zxvf #{node['splunk']['server_home']}/etc/apps/pulse_for_aws_cloudwatch/pymodules/python-dateutil-#{node['splunk']['dateutil_version']}.tar.gz"
    cwd "#{node['splunk']['server_home']}/etc/apps/pulse_for_aws_cloudwatch/pymodules"
  end

  link "Linking dateutils to pulse_for_aws_cloudwatch/bin" do
    to "#{node['splunk']['server_home']}/etc/apps/pulse_for_aws_cloudwatch/pymodules/python-dateutil-#{node['splunk']['dateutil_version']}/dateutil"
    target_file "#{node['splunk']['server_home']}/etc/apps/pulse_for_aws_cloudwatch/bin/dateutil"
  end
 
end