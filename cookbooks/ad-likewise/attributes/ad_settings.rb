default[:authorization] = {}
default[:authorization][:ad_likewise] = {}

# A user in the domain that can join computer to the domain
default[:authorization][:ad_likewise][:auth_domain_user] = "administrator"
default[:authorization][:ad_likewise][:auth_domain_password] = "password"

# Domain, this needs to be the full domain name not the NETBIOS name.
default[:authorization][:ad_likewise][:primary_domain] = "DOMAIN.FQDN"

# Users that will be able to use sudo on the node, spaces will be replaced
# with a '-'.  Make sure to double escape the \ since in the sudoers file the
# \ needs to be escaped.  Prefixed domain names may be the NETBIOS name.
default[:authorization][:ad_likewise][:linux_admins] = [ "DOMAIN\\\\domain-admins" ]

# Array of groups or users that are allowed to login to the node, spaces will
# be replaced by '-'.  Make sure to escape your \'s for ruby only.
# Do not double escape the \.  Prefixed domain names may be the the NETBIOS name
default[:authorization][:ad_likewise][:membership_required] = ["DOMAIN\\domain-users"]
