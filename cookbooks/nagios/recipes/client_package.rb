#
# Author:: Seth Chisamore <schisamo@opscode.com>
# Cookbook Name:: nagios
# Recipe:: client_package
#
# Copyright 2011, Opscode, Inc
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

pkgs = value_for_platform_family(
    "rhel" => { %w{ nrpe nagios-plugins nagios-plugins-disk nagios-plugins-swap nagios-plugins-ssh nagios-plugins-snmp nagios-plugins-smtp nagios-plugins-tcp nagios-plugins-time nagios-plugins-ups nagios-plugins-users nagios-plugins-wave nagios-plugins-sensors nagios-plugins-nagios nagios-plugins-ntp nagios-plugins-ping nagios-plugins-load nagios-plugins-log nagios-plugins-http nagios-plugins-breeze nagios-plugins-by_ssh nagios-plugins-game nagios-plugins-perl nagios-plugins-flexlm nagios-plugins-fping nagios-plugins-hpjd nagios-plugins-icmp nagios-plugins-ide_smart nagios-plugins-ifoperstatus nagios-plugins-ifstatus nagios-plugins-real nagios-plugins-rpc nagios-plugins-cluster nagios-plugins-dig nagios-plugins-dns nagios-plugins-ldap nagios-plugins-ircd nagios-plugins-file_age nagios-plugins-dummy nagios-plugins-mrtg nagios-plugins-mailq nagios-plugins-mrtgtraf nagios-plugins-mysql nagios-plugins-oracle nagios-plugins-pgsql nagios-plugins-procs nagios-plugins-nwstat nagios-plugins-nt nagios-plugins-radius nagios-plugins-overcr },
    "debian" => { %w{ nagios-nrpe-server nagios-plugins nagios-plugins-basic nagios-plugins-standard },
    "default" => %w{ nagios-nrpe-server nagios-plugins nagios-plugins-basic nagios-plugins-standard }
  )

pkgs.each do |pkg|
  package pkg do
    action :install
  end
end