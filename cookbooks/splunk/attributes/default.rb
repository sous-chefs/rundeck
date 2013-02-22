# Name of the cookbook (referenced in forwarder.rb)
default['splunk']['cookbook_name']             = "splunk"

#directories
default['splunk']['server_home']               = "/opt/splunk"
default['splunk']['db_directory']              = "/volr/splunk"

#web config
default['splunk']['web_server_port']           = "80" # Change to 443/other if you're doing ssl
default['splunk']['root_endpoint']             = "/" # Web Endpoint
default['splunk']['browser_timeout']           = "0"
default['splunk']['minify_js']                 = "true"
default['splunk']['minify_css']                = "true"

default['splunk']['use_ssl']                   = false
default['splunk']['ssl_crt']                   = "ssl.crt"
default['splunk']['ssl_key']                   = "ssl.key"

# Dashboards to deploy
default['splunk']['deploy_dashboards']         = true
default['splunk']['dashboards_to_deploy']      = ["apache_http","useragents"]


default['splunk']['server_config_folder']      = "prodlike"

# Static Server Configs (Configs that match regardless of environment -Dev,QA,PL,Prod,Etc)
default['splunk']['static_server_configs']     = ["web","transforms","limits"]

# Dynamic Server Configs (Configs that change per environment)
default['splunk']['dynamic_server_configs']    = ["inputs","props"]

#configuration values for forwarders
default['splunk']['receiver_port']             = "9997"

#Change the default admin password (Username::Password)
default['splunk']['auth']                      = "admin:SomePassword123"

# Set the role of your splunk server/dedicated search head
default['splunk']['server_role']               = "splunk-server"
# Needed for distributed search.  This is assigned to the indexers.
default['splunk']['indexer_role']              = "splunk-indexer"

# limits.conf 
default['splunk']['max_searches_per_cpu']      = 4