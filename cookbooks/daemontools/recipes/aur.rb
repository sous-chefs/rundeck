#
# Cookbook Name:: daemontools
# Recipe:: aur
#
# Copyright 2010-2012, Opscode, Inc.
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

if platform?("arch")
  pacman_aur "daemontools" do
    patches ["daemontools-0.76.svscanboot-path-fix.patch"]
    pkgbuild_src true
    action [:build,:install]
  end
else
  Chef::Log.warn("daemontools installation with AUR doesn't make sense on non-ArchLinux platforms, skipping #{cookbook_name}::#{recipe_name}")
end
