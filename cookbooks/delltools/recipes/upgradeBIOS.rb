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

# I'll add more later to upgrade different models.  I just needed this one immediately.

# This will reboot your server immediately!
if node[:Dell][:BIOS][:C6100][:Version] > node[:dmi][:bios][:version]
  bash "upgradeBIOS_C6100" do
  user "root"
    cwd "/tmp"
    code <<-EOH
    wget ftp://ftp.us.dell.com/bios/PECC6100_BIOS_LX_#{node[:Dell][:BIOS][:C6100][:Version].split(".").join("_")}.BIN
    chmod +x PECC6100_BIOS_LX_#{node[:Dell][:BIOS][:C6100][:Version].split(".").join("_")}.BIN
    /tmp/PECC6100_BIOS_LX_#{node[:Dell][:BIOS][:C6100][:Version].split(".").join("_")}.BIN -q -r
    EOH
  end
end
