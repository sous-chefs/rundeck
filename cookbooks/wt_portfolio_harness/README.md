= DESCRIPTION:
Installs Webtrends Portfolio Harness 

= REQUIREMENTS:
* java
* runit

= ATTRIBUTES:
* user: The user to run the service under
* group: The group to run the service under
* java_home: The location of the JRE on the system
* java_opts - Options to start java (e.g. "-Xms2048m -Djava.net.preferIPv4Stack=true")
* download_url: The fullpath, including the tarball, to the system build

= USAGE:
# Recipe
## default.rb
Installs the harness and sets it up as a runit service.

# Resources / Providers

## wt_portfolio_harness_plugin

Deploys/configures a plugin for the portfolio harness.

### Actions
Action   | Description                   | Default
-------  |-------------                  |---------
create   | Deploy the plugin package     | Yes

### Attributes
Attribute                  | Description                                                                          |Type     | Default
---------                  |-------------                                                                         |-----    |--------
name                       | Name of the plugin package to deploy                                                 | String  | name
download_url							 | URL to download plugin from																													| String  | 
user											 | User to run the plugin under																												  | String  | webtrends
group											 | Group to run the plugin under																											  | String  | webtrends
install_dir								 | Directory to extract the plugin 																											| String  | *plugin_dir*/name
conf_dir									 | Directory to place conf files 																												| String  | *install_dir*/conf
force_deploy							 | Wether or not we should force a deployed(deploy_build=true)												  | Boolean | false
configure 								 | A proc of resources that configure the plugin 																				| Proc    | 
after_deploy							 | A proc of resources that only need to run post-deploy																| Proc    | 
restart    								 | A proc of resources that should run when the plugin changes													| Proc    | Restarts "harness"


### Deploy Flow, the Manifest, and Procs

The goal of this LWRP is to simplify the tasks involved in installing a harness plugin while still offering the ability to add any additional tasks
the plugin creater could need. The LWRP determines if the plugin needs to be installed either via the force flag(set via deploy_build=true) or if the install_dir is found empty. 
Any time a deploy happens a manifest is generated and placed in the same directory. This manifest file is a YAML list of files and their checksums. Ex.
/opt/webtrends/harness/plugins/actioncenter_management_api/lib/mimepull-1.8.jar: e0b2ed6e9ccaafe3e96294a181c09e3aae18aa90
/opt/webtrends/harness/plugins/actioncenter_management_api/lib/lift-json_2.10-2.5-RC2.jar: 0d5de2884f4cf9ad7a5c835bc9078a1472eab24f
/opt/webtrends/harness/plugins/actioncenter_management_api/lib/joda-time-2.1.jar: 8f79e353ef77da6710e1f10d34fc3698eaaacbca
/opt/webtrends/harness/plugins/actioncenter_management_api/lib/logback-classic-1.0.9.jar: 258c3d8f956e7c8723f13fdea6b81e3d74201f68
/opt/webtrends/harness/plugins/actioncenter_management_api/lib/jackson-core-2.1.2.jar: 3df73b1001916d861ea35f81a1da1f91513eccb4 

Every run the current manifest is checked against the file version to see if anything changed in that chef run.

The Procs listed above contain resources in three seperate blocks. 

The 'configure' Proc runs every time, and should contain any tasks that need continous montoring(files to template, services running etc)
The 'after_deploy' Proc only runs after a successful deploy, and should contain any ad hoc tasks needed for that specific plugin only needed on deploy time
The 'restart' Proc runs anytime the manifest changes. It defaults to restarting the harness service.

Example use of LWRP
```
wt_portfolio_harness_plugin "actioncenter_management_api" do
  download_url node['wt_actioncenter_management_api']['download_url']
  force_deploy true if ENV["deploy_build"] == "true"
  after_deploy Proc.new {    
    #copy messages jar to harness
    #until we solve the class loader issues.
    execute "copy messages" do
      command "cp #{new_resource.install_dir}/lib/action-center-messages*.jar #{node['wt_portfolio_harness']['lib_dir']}/."
      action :run
    end
  }
  
  configure Proc.new {
    template "#{new_resource.conf_dir}/config.properties" do 
      source "config.properties.erb" 
      owner "root" 
      group "root" 
      mode 00644 
      variables({ 
        :ads_host => ads_host,
        :secure_config_host => ads_host,
        :authToken => authToken,
        :secure_config_port => ads_ssl_port,
        :cam_host => node['wt_cam']['cam_service_url'],
        :cam_port => "80",
        :kafka_topic => kafka_topic
      })
    end 
  }
end
