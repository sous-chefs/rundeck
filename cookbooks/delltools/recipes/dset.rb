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

# download the application bin and notify the install
remote_file "#{Chef::Config[:file_cache_path]}/delldset_v#{node[:delltools][:dset][:version]}.bin" do
	source "http://ftp.us.dell.com/diags/delldset_v#{node[:delltools][:dset][:version]}.bin"
	mode 00644
	not_if {File.exists?("#{Chef::Config[:file_cache_path]}/delldset_v#{node[:delltools][:dset][:version]}.bin")}
	notifies :run, "execute[installDSET]", :immediately
end

# install DSET
execute "installDSET" do
  user "root"
  cwd "#{Chef::Config[:file_cache_path]}"
  command "chmod +x delldset_v#{node[:delltools][:dset][:version]}.bin; ./delldset_v#{node[:delltools][:dset][:version]}.bin --install"
  action :nothing
end