#
# Cookbook Name:: wt_static_tag_host
# Recipe:: default
#
# Copyright 2012, Webtrends
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

#Enable the server status page
include_recipe "apache2::mod_status"

# disable the default apache site
apache_site "000-default" do
  enable false
end

log "Deploy build is #{ENV["deploy_build"]}"
if ENV["deploy_build"] != "true" then
    log "The deploy_build value is not set or is false so exit here"
else
    log "The deploy_build value is true so un-deploy first"
    include_recipe "wt_static_tag_host::undeploy"

		# template the apache config for the repo site
		template "#{node['apache']['dir']}/sites-available/static_tag_host.conf" do
			source "apache2.conf.erb"
			mode 00644
			variables(:docroot => "/var/www")
			if ::File.symlink?("#{node['apache']['dir']}/sites-enabled/static_tag_host.conf")
				notifies :reload, resources(:service => "apache2")
			end
		end
		
		# create the apache site
		apache_site "static_tag_host" do
			ignore_failure true
			action :create
		end

end