
# Scripted Authentication using encrypted data bags
# We use this implementation to interact with a SSO system using our custom python login scripts

default['splunk']['scripted_auth']                = false

# Directory to deploy the files
default['splunk']['scripted_auth_directory']      = "etc/system/scripted_auth"

# Static files that don't have ruby code.
default['splunk']['scripted_auth_files']          = ["commonAuth.py", "userMapping.py"]

# Templated files that need the ruby code (username/password for third party systems, etc)
default['splunk']['scripted_auth_templates']      = ["crowd_auth.py"]

# The filename to be called for authentication calls
default['splunk']['scripted_auth_script']         = "crowd_auth.py"

# Cache Timings
default['splunk']['scripted_auth_userLoginTTL']	  = "1h"
default['splunk']['scripted_auth_getUserInfoTTL'] = "1h"
default['splunk']['scripted_auth_getUsersTTL']	  = "1h"

# Data bag information if needed
# user: username
# password: pass
default['splunk']['scripted_auth_data_bag_group'] = "apps"
default['splunk']['scripted_auth_data_bag_name']  = "splunk_auth"
default['splunk']['data_bag_key']                 = ""
