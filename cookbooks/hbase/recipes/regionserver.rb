#
# Cookbook Name:: hbase
# Recipe:: regionserver
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

include_recipe 'hbase'

if node.attribute?("nagios")
  #Create a nagios nrpe check for the hbase log regarding IPC Server handler errors
    nagios_nrpecheck "hbase_log_check_server_error" do
        command "sudo #{node['nagios']['plugin_dir']}/check_log"
        parameters "-F /var/log/hbase/hbase-hadoop-regionserver-#{node['fqdn']}.log -O /tmp/NRPE_check_log_hbase.log -q 'WARN org.apache.hadoop.ipc.HBaseServer: PRI IPC Server handler'"
        action :add
    end
end