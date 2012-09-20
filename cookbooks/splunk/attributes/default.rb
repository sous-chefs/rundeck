# Name of the cookbook (referenced in forwarder.rb)
default['splunk']['cookbook_name']                = "splunk"

#indexer configuration attributes
default['splunk']['indexer_name']                 = "splunk_indexers"

#directories
default['splunk']['forwarder_home']               = "/opt/splunkforwarder"
default['splunk']['server_home']                  = "/opt/splunk"
default['splunk']['db_directory']                 = "/volr/splunk"

#web config
default['splunk']['web_server_port']              = "443"
default['splunk']['browser_timeout']              = "0"
default['splunk']['minify_js']                    = "true"
default['splunk']['minify_css']                   = "true"

default['splunk']['use_ssl']                      = false
default['splunk']['ssl_crt']                      = "ssl.crt"
default['splunk']['ssl_key']                      = "ssl.key"

# Dashboards to deploy
default['splunk']['deploy_dashboards']            = true
default['splunk']['dashboards_to_deploy']         = ["apache_http","useragents"]

# Static Server Configs (Configs that match regardless of environment -Dev,QA,PL,Prod,Etc)
default['splunk']['static_server_configs']        = ["web","transforms"]

# Dynamic Server Configs (Configs that change per environment)
default['splunk']['dynamic_server_configs']       = ["inputs","props"]

#configuration values for forwarders
default['splunk']['receiver_port']                = "9997"
default['splunk']['limits_thruput']               = "256"

#Change the default admin password (Username::Password)
default['splunk']['auth']                         = "admin:SomePassword123!!"

#Set the role of your splunk indexer
default['splunk']['server_role']                  = "splunk-server"

#Set the default role for splunk forwarders
default['splunk']['forwarder_role']               = "default"
default['splunk']['forwarder_config_folder']      = "prodlike"
default['splunk']['server_config_folder']         = "prodlike"

##Set the Splunk Version to be used
#Server
default['splunk']['server_root']                  = "http://download.splunk.com/releases"
default['splunk']['server_version']               = "4.3"
default['splunk']['server_build']                 = "115073"
#Forwarder
default['splunk']['forwarder_root']               = "http://download.splunk.com/releases"
default['splunk']['forwarder_version']            = "4.3"
default['splunk']['forwarder_build']              = "115073"

# Unix app version number 
default['splunk']['unix_app_file']                = "unix.tar.gz"
default['splunk']['unix_app_version']             = "4.5"

# PDF Server version number
default['splunk']['pdf_server_file']              = "pdfserver.tar.gz"
default['splunk']['pdf_server_version']           = "1.3"

# Deployment Monitor Version Number
default['splunk']['deployment_mon_file']          = "SplunkDeploymentMonitor.tar.gz"
default['splunk']['deployment_mon_version']       = "4.2.2"

# Splunk SOS app
default['splunk']['splunk_sos_file']              = "sos.tar.gz"
default['splunk']['splunk_sos_version']           = "2.0.0"

# Splunk SOS Required App
default['splunk']['sideview_file']                = "sideview_utils.tar.gz"
default['splunk']['sideview_version']             = "1.2.5"

# Pulse for AWS Cloudwatch App
default['splunk']['pulse_app_file']               = "pulse_for_aws_cloudwatch.tar.gz"
default['splunk']['pulse_app_version']            = "1.0"
default['splunk']['boto_remote_location']         = "http://boto.googlecode.com/files"
default['splunk']['boto_version']                 = "2.1.1"
default['splunk']['dateutil_remote_location']     = "http://labix.org/download/python-dateutil"
default['splunk']['dateutil_version']             = "1.5"