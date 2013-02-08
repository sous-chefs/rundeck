#
# Cookbook Name:: storm
# Recipe:: undeploy
#
# Copyright 2012, Webtrends, Inc.
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

runit_service "supervisor" do
    action :disable
end

# try to stop the service, but allow a failure without printing the error
service "supervisor" do
  action [:stop, :disable]
  ignore_failure true
end

# and just in case that did not work, we do a kill on all storm user processes
execute "kill" do
  user    "root"
  group   "root"
  returns [0,1]
  command "killall -u storm"
end