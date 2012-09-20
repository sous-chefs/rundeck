#
# Cookbook Name:: splunk
# Recipe:: forwarder
# 
# Copyright 2011-2012, BBY Solutions, Inc.
# Copyright 2011-2012, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

directory "/opt" do
  mode "0755"
  owner "root"
  group "root"
end

splunk_cmd = "#{node['splunk']['forwarder_home']}/bin/splunk"
splunk_package_version = "splunkforwarder-#{node['splunk']['forwarder_version']}-#{node['splunk']['forwarder_build']}"

splunk_file = splunk_package_version + 
  case node['platform']
  when "centos","redhat","fedora"
    if node['kernel']['machine'] == "x86_64"
      "-linux-2.6-x86_64.rpm"
    else
      ".i386.rpm"
    end
  when "debian","ubuntu"
    if node['kernel']['machine'] == "x86_64"
      "-linux-2.6-amd64.deb"
    else
      "-linux-2.6-intel.deb"
    end
  end

remote_file "/opt/#{splunk_file}" do
  source "#{node['splunk']['forwarder_root']}/#{node['splunk']['forwarder_version']}/universalforwarder/linux/#{splunk_file}"
  action :create_if_missing
end

package splunk_package_version do
  source "/opt/#{splunk_file}"
  case node['platform']
  when "centos","redhat","fedora"
    provider Chef::Provider::Package::Rpm
  when "debian","ubuntu"
    provider Chef::Provider::Package::Dpkg
  end
end

execute "#{splunk_cmd} start --accept-license --answer-yes" do
  not_if do
    `#{splunk_cmd} status | grep 'splunkd'`.chomp! =~ /^splunkd is running/
  end
end

execute "#{splunk_cmd} enable boot-start" do
  not_if do
    File.symlink?('/etc/rc4.d/S20splunk')
  end
end

service "splunk" do
  action [ :nothing ]
  supports :status => true, :start => true, :stop => true, :restart => true
end

splunk_password = node['splunk']['auth'].split(':')[1]
execute "#{splunk_cmd} edit user admin -password #{splunk_password} -roles admin -auth admin:changeme && echo true > /opt/splunk_setup_passwd" do
  not_if do
    File.exists?("/opt/splunk_setup_passwd")
  end
end

if Chef::Config[:solo]
  Chef::Log.warn("This recipe uses search. Chef Solo does not support Search")
else
  splunk_servers = search(:node, "role:#{node['splunk']['server_role']}")
end

template "#{node['splunk']['forwarder_home']}/etc/system/local/outputs.conf" do
	source "forwarder/outputs.conf.erb"
	owner "root"
	group "root"
	mode "0644"
	variables :splunk_servers => splunk_servers
	notifies :restart, resources(:service => "splunk")
end

["limits"].each do |cfg|
  template "#{node['splunk']['forwarder_home']}/etc/system/local/#{cfg}.conf" do
   	source "forwarder/#{cfg}.conf.erb"
   	owner "root"
   	group "root"
   	mode "0640"
    notifies :restart, resources(:service => "splunk")
   end
end

# Find the inputs file to move.  There will be the default and then we will over-write it as necessary
node.cookbook_collection[node['splunk']['cookbook_name']].template_filenames.each do |filename|
 inputsfile = "forwarder/#{node['splunk']['forwarder_config_folder']}/#{node['splunk']['forwarder_role']}.inputs.conf.erb"
  # Did it this way so we don't get spammed with stupid crap for each role
    template "Moving inputs file for role: #{node['splunk']['forwarder_role']}" do
 	    path "node['splunk']['forwarder_home']/etc/system/local/inputs.conf"
	    source inputsfile
      owner "root"
      group "root"
      mode "0640"
      only_if {filename == inputsfile}
      notifies :restart, resources(:service => "splunk")
  end
end


template "/etc/init.d/splunk" do
  source "forwarder/splunk.erb"
  mode "0755"
  owner "root"
  group "root"
end