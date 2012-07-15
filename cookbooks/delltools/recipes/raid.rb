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

# Install utilities / monitors for the LSI SAS 9260
if node[:kernel][:modules].include? 'megaraid_sas' then

	# Fetch the Megaraid RPM
	remote_file "#{Chef::Config[:file_cache_path]}/#{node[:delltools][:raid][:megacli_packagename]}" do
		source node[:delltools][:raid][:megacli_url]
		mode 00644
		action :create_if_missing
	end
	
	# Install the megaraid cli with --nodeps since LSI makes bad packages
	package "MegaCli" do
		action :install
		source "#{Chef::Config[:file_cache_path]}/#{node[:delltools][:raid][:megacli_packagename]}"
		provider Chef::Provider::Package::Rpm
		options "--nodeps"
	end
	
	# Add nagios check for the LSI 9260 card to nrpe if nagios is being used
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
	
end


# Install utilities / monitors for the PERC H200 aka LSI SAS 2008
if node[:kernel][:modules].include? 'mpt2sas' then
	
	# Download SAS-2 Integrated RAID Configuration Utility
	remote_file "#{Chef::Config[:file_cache_path]}/#{node[:delltools][:raid][:sas2ircu_packagename]}" do
		source node[:delltools][:raid][:sas2ircu_url]
		mode 00644
		action :create_if_missing
	end
	
	# uncompress the zip to a temp dir
	execute "unzip" do
		user  "root"
		group "root" 
		command "unzip -d #{Chef::Config[:file_cache_path]}/sas2ircu #{Chef::Config[:file_cache_path]}/#{node[:delltools][:raid][:sas2ircu_packagename]}"
		action :nothing
		subscribes :run, resources(:remote_file => "#{Chef::Config[:file_cache_path]}/#{node[:delltools][:raid][:sas2ircu_packagename]}"), :immediately
	end
	
	# copy the utility into place
	execute "copy" do
		command "cp #{Chef::Config[:file_cache_path]}/sas2ircu/sas2ircu_linux_x86_rel/sas2ircu /usr/sbin/sas2ircu"
		action :nothing
		subscribes :run, resources(:execute => "unzip")
	end
	
	# Add nagios check for the PERC h200 card to nrpe if nagios is being used
	if node.attribute?("nagios")
		cookbook_file "#{node['nagios']['plugin_dir']}/check_sas2ircu" do
			source "check_sas2ircu"
			mode 00755
		end
		
		nagios_nrpecheck "dell_raid_check" do
			command "#{node['nagios']['plugin_dir']}/check_sas2ircu"
			action :add
		end
	end
	
end