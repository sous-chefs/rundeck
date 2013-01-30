#
# Cookbook Name:: ad-auth
# Recipe:: linux
# Author:: Tim Smith <tim.smith@webtrends.com>, Peter Crossley <peter.crossley@webtrends.com>
#
# Based on the ad-likewise cookbook: Copyright 2010, Bryan McLellan
# Copyright 2012, Tim Smith and Peter Crossly
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
    action :nothing
    only_if { File.exists?("/etc/init.d/${svc}") }
  end
end

package "psmisc"

# Run apt-get update if the package has never been installed on Ubuntu due to caches
execute "update_apt" do
  command "apt-get update"
  action :run
  only_if { (! File.exists?("/opt/likewise")) & (node.platform == "ubuntu") } 
end

# You will need to add likewise-open 6.1 to a local repo from http://www.beyondtrust.com/Products/PowerBroker-Identity-Services-Open-Edition/
package "likewise-open" do
	action :install
	if node.platform == "ubuntu"
		options "--force-yes"
		version "6.1.0-2" if node.platform_version.to_i < 12
	end
	if node.platform == "centos"
		version "6.1.0-2.UNKNOWN.8780"
	end
end

# Pull the necessary creds from the appropriate authorization databag depending on the ad_network attribute
ad_config = data_bag_item('authorization', node[:authorization][:ad_auth][:ad_network])

# Change hostname to unique name
if ad_config['usenameprefix'] then
  execute "prepare-likewise" do
    command "/usr/bin/domainjoin-cli setname #{node.chef_environment}-#{node[:hostname]}"
    only_if "lw-get-status |grep -q Status.*Unknown"
  end
end

# Join the primary_domain if we aren't a member already
execute "initialize-likewise" do
  command "/usr/bin/domainjoin-cli join #{ad_config['primary_domain']} #{ad_config['auth_domain_user']} \"#{ad_config['auth_domain_password']}\""
  only_if "/opt/likewise/bin/lw-get-status | grep -q Status.*Unknown"
end

# Load the registry file that provides all likewise configuration options
execute "load-reg" do
  command "/opt/likewise/bin/lwregshell import /etc/likewise/lsassd.reg"
  action :nothing
end

# Reload the config to pull in any changes we've made
execute "likewise-config-reload" do
  command "/opt/likewise/bin/lw-refresh-configuration"
  action :nothing
  subscribes :run, resources(:execute => "load-reg"), :immediately
end

# Clear any auth caches
execute "clear-cache" do
  command "/opt/likewise/bin/lw-ad-cache --delete-all"
  ignore_failure true
  action :nothing
  subscribes :run, resources(:execute => "likewise-config-reload"), :immediately
end

# Make sure likewise is started and if it's not then clear the caches, and reload the config
service "likewise" do
  supports :restart => true, :status => true
  action [ :enable, :start ]
  notifies :run, resources(:execute => "clear-cache"), :immediately
end

# Make sure eventlogd lwiod lwregd netlogond are enabled and started
for lwservice in [ "eventlogd", "lwiod", "lwregd", "netlogond"  ] do
  service lwservice do
    supports :restart => true, :status => true
    action [ :enable, :start ]
    only_if { File.exists?("/etc/init.d/${svc}") }
  end
end

# Build the registry file that contains likewise config options
template "/etc/likewise/lsassd.reg" do
  source "lsassd.reg.erb"
  mode 00644
  variables(
    :ad_membership_required => ad_config['membership_required']
  )
  notifies :run, resources(:execute => "load-reg"), :immediately
end

# Create a new nsswitch that doesn't include zeroconf settings
cookbook_file "nsswitch.conf" do
  source "nsswitch.conf"
  path "/etc/nsswitch.conf"
  owner "root"
  group "root"
  mode 00644
end
