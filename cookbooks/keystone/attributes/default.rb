########################################################################
# Toggles - These can be overridden at the environment level
default["developer_mode"] = false  # we want secure passwords by default
########################################################################

# Adding these as blank
# this needs to be here for the initial deep-merge to work
default["credentials"]["EC2"]["admin"]["access"] = ""
default["credentials"]["EC2"]["admin"]["secret"] = ""

default["keystone"]["db"]["name"] = "keystone"
default["keystone"]["db"]["username"] = "keystone"
# Replacing with OpenSSL::Password in recipes/server.rb
# default["keystone"]["db"]["password"] = "keystone"

default["keystone"]["verbose"] = "False"
default["keystone"]["debug"] = "False"

# new endpoint location stuff
default["keystone"]["services"]["admin-api"]["scheme"] = "http"
default["keystone"]["services"]["admin-api"]["network"] = "nova"
default["keystone"]["services"]["admin-api"]["port"] = "35357"
default["keystone"]["services"]["admin-api"]["path"] = "/v2.0"

default["keystone"]["services"]["service-api"]["scheme"] = "http"
default["keystone"]["services"]["service-api"]["network"] = "public"
default["keystone"]["services"]["service-api"]["port"] = "5000"
default["keystone"]["services"]["service-api"]["path"] = "/v2.0"

# Logging stuff
default["keystone"]["syslog"]["use"] = false
default["keystone"]["syslog"]["facility"] = "LOG_LOCAL3"
default["keystone"]["syslog"]["config_facility"] = "local3"

# default["keystone"]["roles"] = [ "admin", "Member", "KeystoneAdmin", "KeystoneServiceAdmin", "sysadmin", "netadmin" ]
default["keystone"]["roles"] = [ "admin", "Member", "KeystoneAdmin", "KeystoneServiceAdmin" ]

#TODO(shep): this should probably be derived from keystone.users hash keys
default["keystone"]["tenants"] = [ "admin", "service"]

default["keystone"]["admin_user"] = "admin"

default["keystone"]["users"] = {
    default["keystone"]["admin_user"]  => {
        "password" => "secrete",
        "default_tenant" => "admin",
        "roles" => {
            "admin" => [ "admin" ],
            "KeystoneAdmin" => [ "admin" ],
            "KeystoneServiceAdmin" => [ "admin" ]
        }
    },
    "monitoring" => {
        "password" => "",
        "default_tenant" => "service",
        "roles" => {
            "Member" => [ "admin" ]
        }
    }
}


# platform defaults
case platform
when "fedora", "redhat", "centos"                                 # :pragma-foodcritic: ~FC024 - won't fix this
  default["keystone"]["platform"] = {
    "mysql_python_packages" => [ "MySQL-python" ],
    "keystone_packages" => [ "openstack-keystone" ],
    "keystone_service" => "openstack-keystone",
    "keystone_process_name" => "keystone-all",
    "package_options" => ""
  }
when "ubuntu"
  default["keystone"]["platform"] = {
    "mysql_python_packages" => [ "python-mysqldb" ],
    "keystone_packages" => [ "keystone" ],
    "keystone_service" => "keystone",
    "keystone_process_name" => "keystone-all",
    "package_options" => "-o Dpkg::Options::='--force-confold' -o Dpkg::Options::='--force-confdef'"
  }
end

