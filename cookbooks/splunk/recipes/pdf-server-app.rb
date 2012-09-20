#
# Cookbook Name:: splunk
# Recipe:: pdf-server-app
#
# Copyright 2011-2012, BBY Solutions, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

splunk_app_install "Installing #{node['splunk']['pdf_server_file']} -- Version: #{node['splunk']['pdf_server_version']}" do
  action                    [:create_if_missing]
  app_file                  node['splunk']['pdf_server_file']
  app_version               node['splunk']['pdf_server_version']
  local_templates_directory "pdf-server-app"
  local_templates           ["app.conf.erb"]
  remove_dir_on_upgrade     "true"
  case node['platform']
    when "centos","redhat","fedora"
      required_dependencies ["Xvfb","xauth","bitstream-vera-fonts"]
    when "debian","ubuntu"
      required_dependencies ["xvfb","xauth","fontconfig","libxrender1","libxinerama1"]
  end
end
