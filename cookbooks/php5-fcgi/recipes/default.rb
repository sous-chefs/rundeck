#
# Cookbook Name:: php5-fcgi
# Recipe:: default
#
# Copyright 2012, Webtrends Inc

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

package "php5-cgi"
package "spawn-fcgi"

execute "php-fastcgi-updaterc" do
  command "update-rc.d php-fastcgi defaults"
  user "root"
  group "root"
  action :nothing
end

cookbook_file "/etc/init.d/php-fastcgi" do
  source "php-fastcgi"
  owner "root"
  group "root"
  mode 00555
  notifies :run, resources(:execute => "php-fastcgi-updaterc")
end

template "/usr/bin/php-fastcgi" do
  source "php-fastcgi.erb"
  owner "root"
  group "root"
  mode 00555
end

service "php-fastcgi" do
  supports :status => false, :restart => false, :reload => false
  status_command "ps aux | grep [p]hp5-cgi"
  action :start
end

cookbook_file "/etc/php5/cli/php.ini" do
  source "php.ini"
  owner "root"
  group "root"
  mode 00644
  notifies :restart, resources(:service => "php-fastcgi")
end

