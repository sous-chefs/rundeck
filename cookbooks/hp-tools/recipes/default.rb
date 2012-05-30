#
# Cookbook Name:: hp-tools
# Recipe:: default
#
# Copyright 2012, Webtrends
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

# Restart hp-snmp-agents later. it is buggy and has issues with its own libraries when started on package installation

#Exit the recipe if the sda drive doesn't have a vendor of HP.  This appears to be the only way to find HP hardware
if node[:block_device][:sda][:vendor] != "HP" then
	return
end

include_recipe snmp

service "hp-snmp-agents" do
  action :nothing
end

package "hp-health"
package "hpacucli"
package "cpqacuxe"
package "hp-snmp-agents" do
  notifies :restart, resources(:service => "hp-snmp-agents")
end
package "hp-smh-templates"
package "hpsmh"

service "hpsmhd" do
  action [ :start, :enable ]
end

service "snmpd" do
  action [ :start, :enable ]
end

cookbook_file "/opt/hp/hpsmh/conf/smhpd.xml" do
  source "smhpd.xml"
  owner "root"
  group "root"
  mode 00644
  notifies :restart, resources(:service => "hpsmhd")
end

cookbook_file "/etc/snmp/snmpd.conf" do
  source "snmpd.conf"
  owner "root"
  group "root"
  mode 00644
  notifies :restart, resources(:service => "snmpd")
end

cookbook_file "/etc/default/snmpd" do
  source "snmpd.default"
  owner "root"
  group "root"
  mode 0644
  notifies :restart, resources(:service => "snmpd")
end

sudoers "hpsmh-snmptrap" do
  group "hpsmh"
  rights "ALL=NOPASSWD:/usr/bin/snmptrap"
end

