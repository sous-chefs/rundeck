#
# Author:: Peter Crossley <peterc@xley.org>
# Cookbook Name:: ad-likewise
# Recipe:: default
#
# Copyright 2009, Peter Crossley
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

# Make sure we dont have any existing authentication plugins installed.

if platform?("redhat", "centos")

end

if platform?("ubuntu")

  [
   "nscd",
   "winbind",
  ].each do |pack|
    package (pack) { action :purge }
  end

  package "likewise-open5" do
    action :install
  end

end

execute "initialize-likewise" do
  command "domainjoin-cli join #{node[:authorization][:ad_likewise][:primary_domain]} #{node[:authorization][:ad_likewise][:auth_domain_user]} \"#{node[:authorization][:ad_likewise][:auth_domain_password]}\""
  not_if "lw-get-current-domain"
end

execute "pam-auth-update" do
  command "pam-auth-update --package --force"
  action :nothing
  subscribes :run, resources(:execute => "initialize-likewise")
end

@node[:authorization][:ad_likewise][:linux_admins].each do |admin_group|
   sudoers "linux-admins" do
    group admin_group
  end
end

template "/etc/likewise-open5/lsassd.conf" do
  source "lsassd.conf.erb"
  mode "0644"
  variables(
    :ad_membership_required => node[:authorization][:ad_likewise][:membership_required]
  )
end

service "lsassd" do
  supports :restart => true, :status => true
  action [ :enable, :start ]
  subscribes :restart, resources(:template => "/etc/likewise-open5/lsassd.conf")
end

service "netlogond" do
  supports :restart => true, :status => true
  action [ :enable, :start ]
  subscribes :restart, resources(:template => "/etc/likewise-open5/lsassd.conf")
end

service "dcerpcd" do
  supports :restart => true, :status => true
  action [ :enable, :start ]
  subscribes :restart, resources(:template => "/etc/likewise-open5/lsassd.conf")
end

