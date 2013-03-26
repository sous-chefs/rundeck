#
# Cookbook Name:: graphite
# Attribute:: default
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

default[:graphite][:version] = "0.9.10"
default[:graphite][:python_version] = "2.6"
version = node[:graphite][:version]
series = node[:graphite][:version].split(".").first(2).join(".")

default[:graphite][:carbon][:uri] = "https://launchpad.net/graphite/#{series}/#{version}/+download/carbon-#{version}.tar.gz"
default[:graphite][:carbon][:checksum] = "4f37e00595b5b"

default[:graphite][:whisper][:uri] = "https://launchpad.net/graphite/#{series}/#{version}/+download/whisper-#{version}.tar.gz"
default[:graphite][:whisper][:checksum] = "36b5fa9175262"

default[:graphite][:graphite_web][:uri] = "https://launchpad.net/graphite/#{series}/#{version}/+download/graphite-web-#{version}.tar.gz"
default[:graphite][:graphite_web][:checksum] = "4fd1d16cac398"

default[:graphite][:web_app_timezone] = "UTC"
default[:graphite][:carbon][:local_data_dir] = "/opt/graphite/storage/whisper/"
default[:graphite][:carbon][:line_receiver_interface] =   "0.0.0.0"
default[:graphite][:carbon][:pickle_receiver_interface] = "0.0.0.0"
default[:graphite][:carbon][:cache_query_interface] =     "0.0.0.0"

default[:graphite][:password] = "change_me"
default[:graphite][:url] = "graphite"