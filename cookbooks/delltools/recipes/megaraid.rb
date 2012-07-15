# Copyright 2012, Tim Smith - Webtrends Inc
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

# Exit the recipe if system's manufacturer as detected by ohai does not match "Dell"
if !node[:kernel][:modules].include? 'megaraid_sas' then
  return
end

# Fetch the Megaraid RPM
remote_file "#{Chef::Config[:file_cache_path]}/#{node[:delltools][:megaraid][:megacli_packagename]}" do
  source node[:delltools][:megaraid][:megacli_url]
  mode 00644
  action :create_if_missing
end

# Install the megaraid cli with --nodeps since LSI makes bad packages
package "MegaCli" do
  action :install
  source "#{Chef::Config[:file_cache_path]}/#{node[:delltools][:megaraid][:megacli_packagename]}"
  provider Chef::Provider::Package::Rpm
  options "--nodeps"
end

# Add nagios check for the megaraid card to nrpe if nagios is being used
if node.attribute?("nagios")
  cookbook_file "#{node['nagios']['plugin_dir']}/check_megaraid_sas" do
    source "check_megaraid_sas"
    mode 00755
  end
  
	nagios_nrpecheck "dell_raid_check" do
		command "#{node['nagios']['plugin_dir']}/check_megaraid_sas"
		action :add
	end
end