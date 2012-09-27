#
# Author:: Seth Chisamore (<schisamo@opscode.com>)
# Cookbook Name:: iis
# Attribute:: webpi
#
# Copyright:: Copyright (c) 2011 Opscode, Inc.
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

default['webpi']['url']       = '"http://download.microsoft.com/download/6/8/D/68DAB32D-10B6-461D-8FF5-43CE9BDA6CE5/WebPICMD.zip'
default['webpi']['checksum']  = 'c04a42c8874ed24a6e547b06f1d5a100324caf18'

default['webpi']['home'] = "#{ENV['SYSTEMDRIVE']}\\webpi"
