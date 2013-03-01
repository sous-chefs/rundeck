#
# Cookbook Name:: graphite
# Recipe:: default
#
# Copyright 2011, Heavy Water Software Inc.
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

# CentOS/RH prerequisites
if platform?("redhat", "centos", "amazon", "scientific", "fedora")
  %w{ bitmap bitmap-fonts gcc gcc-c++ git glibc-devel openssl-devel python-devel python-twisted python-memcached python-zope-interface python-rrdtool python-sqlite2 }.each do |pkg|
    package pkg
  end
end

# Debian/Ubuntu prerequisites
if platform?("debian","ubuntu")
  %w{ bzr curl erlang-os-mon erlang-snmp git-core g++ libapache2-mod-wsgi libapache2-mod-python libapr1 libaprutil1 libaprutil1-dbd-sqlite3 libaprutil1-ldap libssl-dev python-dev python-setuptools python-simplejson python-memcache python-pysqlite2 python-rrdtool python-twisted sqlite3 }.each do |pkg|
    package pkg
  end
end

include_recipe "graphite::whisper"
include_recipe "graphite::web"
include_recipe "graphite::carbon"
