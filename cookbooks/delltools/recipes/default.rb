# Copyright 2011, Nathan Milford
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

#Exit the recipe if system's manufacturer as detected by ohai does not match "Dell"
if !node[:dmi][:system][:manufacturer].include? 'Dell' then
	return
end

# Most Dell stuff on CentOS / Redhat needs these.
%w{procmail compat-libstdc++-33}.each do |dellpkg|
		package dellpkg
end

# You'll probably want ipmitool for interacting with the server
package "ipmitool" do
    action :install
end