Attributes
===========

apps
----
* `node['splunk']['unix_app_file']` - The name of the unix app file.  
	- File location: files/default/apps
* `node['splunk']['unix_app_version']` - The version number associated with this file.

* `node['splunk']['pdf_server_file']` - The name of the pdf server app file. 
	- File location: files/default/apps
* `node['splunk']['pdf_server_version']` - The version number associated with this file.

* `node['splunk']['deployment_mon_file']` - The name of the deployment monitor app file.  
	- File location: files/default/apps
* `node['splunk']['deployment_mon_version']` - The version number associated with this file.

* `node['splunk']['splunk_sos_file]` - The name of the Splunk on Splunk app file. 
	- File location: files/default/apps
* `node['splunk']['splunk_sos_version]` - The version number associated with this file.

* `node['splunk']['sideview_utils_file]` - The name of the sideview utils app file.  
	- File location: files/default/apps
* `node['splunk']['sideview_utils_version']` - The version number associated with this file.

* `node['splunk']['pulse_app_file']` - The name of the Pulse for AWS Cloudwatch app file.  
	- File location: files/default/apps
* `node['splunk']['pulse_app_version']` - The version number associated with this file.
* `node['splunk']['boto_remote_location]` - The base URL for downloading the Python boto library
* `node['splunk']['boto_verison]` - The version of boto to download
* `node['splunk']['dateutil_remote_location]` - The base URL for downloading the Python dateutil library
* `node['splunk']['dateutil_version]` - The version of python-dateutil to download

default
-------
* `node['splunk']['cookbook_name']` - The name of the directory in which the cookbook runs.

* `node['splunk']['server_home']` - The directory in which to install the Splunk Server
* `node['splunk']['db_directory']` - The directory to use for the Splunk Server Database.
	- File location: templates/server/splunk-launch.conf.erb

* `node['splunk']['web_server_port']` - The port number to assign the web server (httpport).
	- File location: templates/server/web.conf.erb
* `node['splunk']['root_endpoint']` - The endpoint for the splunk web instance
* `node['splunk']['browser_timeout']` - The inactivity timeout (ui_inactivity_timeout).
	- File location: templates/server/web.conf.erb
* `node['splunk']['minify_js']` - Indicates whether the static JS files for modules are consolidated and minified.
	- File location: templates/server/web.conf.erb
* `node['splunk']['minify_css']` - Indicates whether the static CSS files for modules are consolidated and minified.
	- File location: templates/server/web.conf.erb

* `node['splunk']['use_ssl']` - Toggles between http or https (enableSplunkWebSSL).
	- File location: templates/server/web.conf.erb
* `node['splunk']['ssl_crt']` - The cert file name if you are using the SSL web frontend. 
	- File location: files/default/ssl
* `node['splunk']['ssl_key']` - The private key file if you are using the SSL web frontend.
	- File location: files/default/ssl

* `node['splunk']['deploy_dashboards']` - Toggles deploying dashboards or not
* `node['splunk']['dashboards_to_deploy']` - An array of xml dashboards to copy over. These are the filenames minus the .xml suffix.
	- File location: files/default/dashboards

* `node['splunk']['server_config_folder']` - The folder which contains the environment specific server config files.  It is best to override this attribute per chef role.
	- Folder Location: templates/server/#{node['splunk']['server_config_folder']}
* `node['splunk']['static_server_configs']` - An array of static server configs that *are not* specific to an environment (Dev, QA, PL, Prod, etc).  These are the primary names without the .conf.erb suffix.
	- File Locations: templates/server
* `node['splunk']['dynamic_server_configs']` - An array of dynamic server configs that *are* specific to an environment.  These are the primary names without the .conf.erb suffix. 
	- File Location: templates/server/#{node['splunk']['server_config_folder']}

* `node['splunk']['receiver_port']` - The default port in which to receive data from the forwarders.

* `node['splunk']['auth']` - The default admin password to use instead of splunks "changeme"

* `node['splunk']['server_role']` - The role name of the splunk standalone install / dedicated search head.  Forwarders will search for this role in order to identify the server in which to send the data.
* `node['splunk']['indexer_role']` - The role name of the splunk indexer if using dedicated searching

* `node['splunk']['max_searches_per_cpu']` - The max searches per cpu (limits.conf)


distributed_search
------------------
* `node['splunk']['distributed_search']` - Enable/Disable distributed search
* `node['splunk']['distributed_search_master']` - The local IP of the License Master

forwarder
---------
* `node['splunk']['forwarder_home']` - The directory in which to install the Splunk Forwarder

* `node['splunk']['forwarder_role']` - The name of the splunk forwarder role.  It is best to override this attribute per role.  This is the inputs file that will be moved over on the forwarding server.  
	- File Location: templates/forwarder/#{node['splunk']['forwarder_config_folder']}/#{node['splunk']['forwarder_role']}.inputs.conf.erb
* `node['splunk']['forwarder_config_folder']` - The folder which contains the inputs file for the environment.  It is best to override this attribute per chef role. 
	- Folder Location: templates/forwarder/#{node['splunk']['forwarder_config_folder']}
* `node['splunk']['limits_thruput']` - The max amount of bandwidth, in KBps, the forwarders will use when sending data.  
	- File Location: templates/forwarder/limits.conf.erb
* `node['splunk']['ssl_forwarding']` - true/false to either enable or disable SSL forwarding.
* `node['splunk']['ssl_forwarding_cacert']` - Name of the CA Cert
	- File location: files/default/ssl/forwarders
* `node['splunk']['ssl_forwarding_servercert']` - Name of the Server Cert
	- File location: files/default/ssl/forwarders
* `node['splunk']['ssl_forwarding_pass']` - Password for the certs

scripted_auth
-------------

* `node['splunk']['scripted_auth']` - Enable Scripted Authentcation
* `node['splunk']['scripted_auth_directory']` - The directory to place the authentication scripts.  This is appended to the base install directory

* `node['splunk']['scripted_auth_files'] ` - An array of static cookbook files to deploy.
	- File Location: files/default/scripted_auth
	- Deployed to: `node['splunk']['scripted_auth_directory']`
* `node['splunk']['scripted_auth_templates']` - An array of templates to deploy.
	- File Location: templates/default/server/scripted_auth
	- Deployed to: `node['splunk']['scripted_auth_directory']`
* `node['splunk']['scripted_auth_script']` - The main script that will be called for authentication

* `node['splunk']['scripted_auth_userLoginTTL']` - TTL to cache user login information
* `node['splunk']['scripted_auth_getUserInfoTTL']` - TTL to cache user information
* `node['splunk']['scripted_auth_getUsersTTL']` - TTL to cache all user information

* `node['splunk']['scripted_auth_data_bag_group']` - The data bag group (if using data bags to deploy user/passwords in your auth file)
* `node['splunk']['scripted_auth_data_bag_name']` - The data bag name (if using data bags to deploy user/passwords in your auth file)
* `node['splunk']['data_bag_key']` - The data bag secret key.

versions
--------
* `node['splunk']['server_root']` - The base URL that splunk uses to download release files for Splunk Server
* `node['splunk']['server_version']` - The specific version of Splunk Server to download
* `node['splunk']['server_build]` - The specific build number of Splunk Server to download

* `node['splunk']['forwarder_root']` - The base URL that splunk uses to download release files for Splunk Forwarder
* `node['splunk']['forwarder_version']` - The specific version of Splunk Forwarder to download
* `node['splunk']['forwarder_build]` - The specific build number of Splunk Forwarder to download


License and Author
==================

Author:: Bryan Brandau (<bryan.brandau@bestbuy.com>)
Author:: Andrew Painter (<andrew.painter@bestbuy.com>)
Author:: Aaron Peterson (<aaron@opscode.com>)

Copyright 2011-2012, BBY Solutions, Inc.
Copyright 2011-2012, Opscode, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
