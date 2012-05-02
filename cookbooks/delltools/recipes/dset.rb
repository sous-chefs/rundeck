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

bash "installDSET" do
  user "root"
  cwd "/tmp"
  code <<-EOH
  if [ ! -d /opt/dell/dset ]; then
    wget http://ftp.us.dell.com/diags/delldset_v#{node[:Dell][:DSET][:Version]}.bin
    chmod +x /tmp/delldset_v#{node[:Dell][:DSET][:Version]}.bin
    /tmp/delldset_v#{node[:Dell][:DSET][:Version]}.bin --install
  fi
  EOH
end
