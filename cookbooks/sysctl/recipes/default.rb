#
# Cookbook Name:: sysctl
# Recipe:: default
# Author:: Guilhem Lettron <guilhem.lettron@youscribe.com>
#
# Copyright 2012, Societe Publica.
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

package "fake-procps" do
  action :upgrade
  only_if { platform?("fedora") }
end


# TODO(Youscribe) change this by something more "clean".
execute 'remove old files' do
  command 'rm --force /etc/sysctl.d/50-chef-attributes-*.conf'
  action :run
end

# redhat supports sysctl.d but doesn't create it by default
directory "/etc/sysctl.d" do
  owner 'root'
  group 'root'
  mode '755'
end

if node.attribute?('sysctl')
  node['sysctl'].each do |item|
    f_name = item.first.gsub(' ', '_')
    template "/etc/sysctl.d/50-chef-attributes-#{f_name}.conf" do
      source 'sysctl.conf.erb'
      mode '0644'
      owner 'root'
      group 'root'
      variables(:instructions => item[1])
      notifies :run, "execute[sysctl-p]"
    end
  end
end

execute "sysctl-p" do
  command "find /etc/sysctl.d -type f -exec sysctl -p {} \\;"
end

