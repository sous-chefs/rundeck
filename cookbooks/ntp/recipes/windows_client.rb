#
# Cookbook Name:: ntp
# Recipe:: windows_client
# Author:: Timothy Smith (<tim.smith@webtrends.com>)
#
# Copyright 2012, Webtrends, Inc
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

directory "C:/NTP/etc" do
  inherits true
  action :create
  recursive true
end

cookbook_file "C:/NTP/ntp.ini" do
  source "ntp.ini"
  inherits true
  action :create
end

template "C:\NTP\etc\ntp.conf" do
  source "ntp.conf.erb"
end

if !File.exists?("C:/NTP/bin/ntpd.exe")
  remote_file "#{Chef::Config[:file_cache_path]}/ntpd.exe" do
    source node[:ntp][:package_url]
  end

  execute "ntpd_install" do
    command "#{Chef::Config[:file_cache_path]}\\ntpd.exe /USEFILE=C:\\NTP\\ntp.ini"
  end
end

service node[:ntp][:service] do
  supports :restart => true
  action [ :enable, :start ]
end
