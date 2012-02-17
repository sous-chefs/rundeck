#
# Author:: Bryan McLellan <btm@loftninjas.org>
# Cookbook Name:: ad-likewise
# Recipe:: purge
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

[ "dcerpcd", "netlogond", "eventlogd", "lwregd", "lwiod", "lsassd" ].each do |svc|
  service svc do
    action :stop
    only_if { File.exists?("/etc/init.d/${svc}") }
  end
end

# Remove "Source" packages
[ 
  "likewise-base",
  "likewise-domainjoin",
  "likewise-eventlog",
  "likewise-krb5",
  "likewise-libxml2",
  "likewise-lsass",
  "likewise-lwio",
  "likewise-lwreg",
  "likewise-mod-auth-kerb",
  "likewise-netlogon",
  "likewise-open5",
  "likewise-openldap",
  "likewise-passwd",
  "likewise-pstore",
  "likewise-rpc",
  "likewise-sqlite",
  "likewise-srvsvc",
  "likewise-open",
  "likewise-open5"
].each do |pkg|
  package pkg do
    action :remove
  end
end
