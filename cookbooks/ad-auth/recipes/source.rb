#
# Author:: Peter Crossley <peterc@xley.org>
# Cookbook Name:: ad-likewise
# Recipe:: source
#
# Copyright 2009, Peter Crossley
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

# Make sure we dont have any existing authentication plugins installed.
[
 "nscd",
 "winbind",
].each do |pack|
  package pack do
    action :purge
    ignore_failure true
  end
end

ad_config = data_bag_item('authorization', node[:authorization][:ad_likewise][:ad_network])

execute "pam-auth-update" do
  command "pam-auth-update --package --force"
  not_if do File.exist?("/opt/likewise") end
end

cookbook_file "copy-likewise-installer" do
  path "/tmp/LikewiseIdentityServiceOpen.installer"
  source "LikewiseIdentityServiceOpen-5.4.0.7985-linux-#{node[:kernel][:machine]}-deb-installer"
  mode "0755"
  owner "root"
  group "root"
  not_if do File.exist?("/opt/likewise") end
end

execute "preinstall-likewise1" do
  command "rm /etc/pam.d/chpasswd"
  only_if do File.exist?("/etc/pam.d/chpasswd") end
end

execute "preinstall-likewise2" do
  command "rm /etc/pam.d/newusers"
  only_if do File.exist?("/etc/pam.d/newusers") end
end

execute "install-likewise" do
  command "/tmp/LikewiseIdentityServiceOpen.installer --mode unattended"
  not_if do File.exist?("/opt/likewise") end
end

execute "initialize-likewise" do
  command "/opt/likewise/bin/domainjoin-cli join #{ad_config['primary_domain']} #{ad_config['auth_domain_user']} \"#{ad_config['auth_domain_password']}\""
  only_if "which lw-get-current-domain"
  not_if "/opt/likewise/bin/lw-get-current-domain"
end

ad_config['linux_admins'].each do |admin_group|
   sudoers "linux-admins" do
    group admin_group
  end
end


execute "load-reg" do
  command "/opt/likewise/bin/lwregshell import /etc/likewise/lsassd.reg"
  action :nothing
end

execute "likewise-config-reload" do
  command "/opt/likewise/bin/lw-refresh-configuration"
  action :nothing
  subscribes :run, resources(:execute => "load-reg"), :immediately
end

execute "clear-cache" do
  command "/opt/likewise/bin/lw-ad-cache --delete-all"
  ignore_failure true
  action :nothing
  subscribes :run, resources(:execute => "likewise-config-reload"), :immediately
end

service "lsassd" do
  supports :restart => true, :status => true
  action [ :enable, :start ]
end

service "netlogond" do
  supports :restart => true, :status => true
  action [ :enable, :start ]
end

service "dcerpcd" do
  supports :restart => true, :status => true
  action [ :enable, :start ]
end


### CONFIGS
hack = %x[/opt/likewise/bin/lw-get-status ; if [ $? -ne 0 ]; then /etc/init.d/lsassd restart ; fi]
likewise_ver = %x[/opt/likewise/bin/lw-get-status].match(/Agent version: (.*)/)[1] if File.exists? "/opt/likewise/bin/lw-get-status"
 
if likewise_ver.to_f == 5.4
  template "/etc/likewise/lsassd.reg" do
    source "lsassd.reg.erb"
    mode "0644"
    variables(
      :ad_membership_required => ad_config['membership_required'],
      :lib_dir => "/opt/likewise/lib#{ node[:kernel][:machine] == 'x86_64'? '64' :''}",
      :install_root => "/opt/likewise"
    )
    only_if do File.exist?("/opt/likewise") end
    notifies :run, resources(:execute => "load-reg"), :immediately
  end

else
  # Likewise 5.3 uses config files
  template "/etc/likewise/lsassd.conf" do
    source "lsassd.conf.erb"
    mode "0644"
    variables(
      :ad_membership_required => ad_config['membership_required'],
      :lib_dir => "/opt/likewise/lib#{ node[:kernel][:machine] == 'x86_64'? '64' :''}",
      :install_root => "/opt/likewise"
    )
    only_if do File.exist?("/opt/likewise") end
    notifies :run, resources(:execute => "likewise-config-reload"), :immediately
  end
end


cookbook_file "nsswitch.conf" do
  source "nsswitch.conf"
  path "/etc/nsswitch.conf"
  owner "root"
  group "root"
  mode 0644
end

remote_directory "/etc/pam.d" do
  source "pam.d"
  files_backup 1
  files_owner "root"
  files_group "root"
  files_mode 0644
  owner "root"
  group "root"
  mode 0755
end

