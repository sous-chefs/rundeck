#
# Cookbook Name:: wt_maintenance_site
# Recipe:: default
#
# Copyright 2013, Webtrends
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

# pull some environment attributes
tarball      = node['wt_maintenance_site']['download_url'].split("/")[-1]
download_url = node['wt_maintenance_site']['download_url']
site_dir     = node['wt_maintenance_site']['site_dir']

# disable the default apache site
apache_site "000-default" do
  enable false
end

# deploy the site if the deploy_build flag is set.
if ENV["deploy_build"] == "true" then
    log "The deploy_build value is true so we will grab the tar ball and install"
    
    # Remove any previous install of the site.
    directory site_dir do
      recursive true
      action :delete
    end

    # create the site's root folder.
    directory site_dir do
      action :create
      recursive true
      owner node['apache']['user']
      group node['apache']['group']
    end

    # download the site tarball
    remote_file "#{Chef::Config[:file_cache_path]}/#{tarball}" do
    source download_url
    mode 00644
    end

    # uncompress the sites's tarbarll into the install dir
    execute "tar" do
    user  "root"
    group "root"
    cwd site_dir
    command "tar zxf #{Chef::Config[:file_cache_path]}/#{tarball}"
    end

    # template the apache site config
    template "#{node['apache']['dir']}/sites-available/wt_maintenance_site.conf" do
      source "wt_maintenance_site.conf.erb"
      mode 00644
      variables(:docroot => site_dir)
    end

    # Enable the apache site
    apache_site "wt_maintenance_site.conf" do
      enable true
    end

end
