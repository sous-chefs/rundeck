default['build-essential']['compile_time'] = true

default['rundeck']['configdir'] = '/etc/rundeck'
default['rundeck']['basedir'] = '/var/lib/rundeck'
default['rundeck']['datadir'] = '/var/rundeck'
default['rundeck']['tempdir'] = '/tmp/rundeck'
default['rundeck']['exec_logdir'] = "#{node['rundeck']['basedir']}/logs"
default['rundeck']['deb']['version'] = 'rundeck-2.9.3-1-GA' # rundeck package from rundeck-deb bintray
default['rundeck']['deb']['repo']['url'] = 'https://dl.bintray.com/rundeck/rundeck-deb'
default['rundeck']['deb']['repo']['key'] = '379CE192D401AB61'
default['rundeck']['deb']['repo']['gpgkey'] = 'http://rundeck.org/keys/BUILD-GPG-KEY-Rundeck.org.key'
default['rundeck']['deb']['options'] = false #--force-confdef --force-confold
default['rundeck']['rpm']['version'] = 'rundeck-2.9.3-1.37.GA' # rundeck package from rundeck-rpm bintray
default['rundeck']['rpm']['repo']['url'] = 'https://dl.bintray.com/rundeck/rundeck-rpm'
default['rundeck']['rpm']['repo']['gpgkey'] = 'http://rundeck.org/keys/BUILD-GPG-KEY-Rundeck.org.key'
default['rundeck']['rpm']['repo']['gpgcheck'] = true
default['rundeck']['port'] = 4440
default['rundeck']['jaas'] = 'internal'
default['rundeck']['default_role'] = 'user'
default['rundeck']['security_roles'] = []
default['rundeck']['hostname'] = "rundeck.#{node['domain']}"

# framework properties to add to the framework.properties config
default['rundeck']['framework']['properties'] = {}

default['rundeck']['email'] = "rundeck@#{node['domain']}"
default['rundeck']['restart_on_config_change'] = false
default['rundeck']['log_dir'] = '/var/log/chef-rundeck'
default['rundeck']['tokens_file'] = nil # e.g. '/etc/rundeck/tokens.properties'
default['rundeck']['use_inbuilt_ssl'] = false # Use inbuilt SSL for rundeck server.
default['rundeck']['ssl']['port'] = 4443 # Use while using inbuilt SSL
default['rundeck']['allow_local_https'] = true

# see library for config available
default['rundeck']['api_client_config'] = {}

# configure how long to wait for rundeck service startup
default['rundeck']['service']['retries'] = 60
# seconds between tcp check of rundeck server startup
default['rundeck']['service']['retry_delay'] = 5
default['rundeck']['service']['extra_wait'] = 120

# Used for connecting to the api to manage resources (projects, etc). This user
# also needs to be explicitly listed in the users data bag.
default['rundeck']['admin_user'] = 'admin'

# web server configuration
default['rundeck']['apache-template']['cookbook'] = 'rundeck'
default['rundeck']['use_ssl'] = false
default['rundeck']['cert']['name'] = node['rundeck']['hostname']
default['rundeck']['cert']['cookbook'] = 'rundeck'
default['rundeck']['webcontext'] = '/'

# Only set to https if we are using the inbuilt ssl.
# SSL offloading should pass the X-Forwarded-Proto header as https and leave this a http
default['rundeck']['grails_server_url'] = "#{node['rundeck']['use_inbuilt_ssl'] ? 'https' : 'http'}://#{node['rundeck']['hostname']}"
default['rundeck']['grails_port'] = node['rundeck']['use_ssl'] ? 443 : 80
default['rundeck']['truststore_type'] = 'jks'

default['rundeck']['log_level'] = 'INFO' # ERR,WARN,INFO,VERBOSE,DEBUG
default['rundeck']['rss_enabled'] = true

# java configuration
default['rundeck']['jvm_mem'] = ' -XX:MaxPermSize=256m -Xmx1024m -Xms256m'
default['java']['jdk_version'] = '8'

# Quartz configuration.
default['rundeck']['quartz']['threadPoolCount'] = 10

# login session timeout
default['rundeck']['session_timeout'] = 30

# databag name configuration
default['rundeck']['rundeck_databag_secure'] = 'secure'
default['rundeck']['rundeck_databag'] = 'rundeck'
default['rundeck']['rundeck_projects_databag'] = 'rundeck_projects'
default['rundeck']['rundeck_databag_users'] = 'users'
default['rundeck']['rundeck_databag_aclpolicies'] = nil
default['rundeck']['rundeck_databag_ldap'] = 'ldap'
default['rundeck']['rundeck_databag_certs'] = 'certs'
default['rundeck']['rundeck_databag_rdbms'] = 'rdbms'

# chef-rundeck test what initsystem to use
if node['init_package'] == 'systemd'
  default['rundeck']['chef_rundeck_use_systemd'] = true
elsif node['init_package'] == 'upstart'
  default['rundeck']['chef_rundeck_use_upstart'] = true
else
  default['rundeck']['chef_rundeck_use_runit'] = true
end

default['rundeck']['chef_rundeck_gem'] = nil
default['rundeck']['chef_rundeck_port'] = 9980
default['rundeck']['chef_rundeck_host'] = '0.0.0.0'
default['rundeck']['chef_rundeck_cachetime'] = 30
default['rundeck']['chef_rundeck_partial_search'] = false
default['rundeck']['user'] = 'rundeck'
default['rundeck']['group'] = 'rundeck'
default['rundeck']['user_home'] = '/home/rundeck'
default['rundeck']['chef_config'] = '/etc/chef/rundeck.rb'
default['rundeck']['chef_client_name'] = 'chef-rundeck'
default['rundeck']['chef_rundeck_url'] = "http://chef.#{node['domain']}:#{node['rundeck']['chef_rundeck_port']}"
default['rundeck']['chef_webui_url'] = "https://chef.#{node['domain']}"
default['rundeck']['chef_url'] = "https://chef.#{node['domain']}"
default['rundeck']['chef_configdir'] = '/etc/chef'
default['rundeck']['project_config'] = "#{node['rundeck']['chef_configdir']}/chef-rundeck.json"

# SMTP settings for rundeck notification emails
default['rundeck']['mail']['enable'] = false
default['rundeck']['mail']['host'] = 'localhost'
default['rundeck']['mail']['port'] = '25'
default['rundeck']['mail']['username'] = ''
default['rundeck']['mail']['password'] = ''

#   If you want to use encrypted databags for your windows password and/or public/private key pairs generate a secret using:
#     'openssl rand -base64 512 | tr -d '\r\n' > rundeck_secret'
#   Distrubute to all sytems that will work with rundeck via a recipe and set the path to that file in the following attribute
#
default['rundeck']['secret_file'] = nil

# External Database properties
default['rundeck']['rdbms']['enable'] = false
default['rundeck']['rdbms']['type'] = 'mysql'
default['rundeck']['rdbms']['location'] = 'someIPorFQDN'
default['rundeck']['rdbms']['dbname'] = 'rundeckdb'
default['rundeck']['rdbms']['dialect'] = 'Oracle10gDialect'
default['rundeck']['rdbms']['port'] = '3306'

# Windows Properties
default['rundeck']['windows']['group'] = 'Administrators'
default['rundeck']['windows']['user'] = node['rundeck']['user']
default['rundeck']['windows']['password'] = nil
default['rundeck']['windows']['winrm_auth_type'] = 'basic'
default['rundeck']['windows']['winrm_cert_trust'] = 'all'
default['rundeck']['windows']['winrm_hostname_trust'] = 'all'
default['rundeck']['windows']['winrm_protocol'] = 'https'
default['rundeck']['windows']['winrm_timeout'] = 'PT60.000S'

# LDAP Properties
default['rundeck']['ldap']['debug'] = true
default['rundeck']['ldap']['provider'] = 'ldap://servername:389'
default['rundeck']['ldap']['binddn'] = 'CN=binddn,dc=domain,dc=com'
default['rundeck']['ldap']['bindpwd'] = 'BINDPWD'
default['rundeck']['ldap']['authenticationmethod'] = 'simple'
default['rundeck']['ldap']['forcebindinglogin'] = true
default['rundeck']['ldap']['userbasedn'] = 'ou=Users,dc=domain,dc=com'
default['rundeck']['ldap']['userrdnattribute'] = 'cn'
default['rundeck']['ldap']['useridattribute'] = 'uid'
default['rundeck']['ldap']['userpasswordattribute'] = 'userPassword'
default['rundeck']['ldap']['userobjectclass'] = 'inetOrgPerson'
default['rundeck']['ldap']['rolebasedn'] = 'ou=Groups,dc=domain,dc=com'
default['rundeck']['ldap']['rolenameattribute'] = 'cn'
default['rundeck']['ldap']['rolememberattribute'] = 'uniqueMember'
default['rundeck']['ldap']['roleusernamememberattribute'] = nil # "memberUid"
default['rundeck']['ldap']['roleobjectclass'] = 'groupOfUniqueNames'
default['rundeck']['ldap']['roleprefix'] = 'rundeck-'
default['rundeck']['ldap']['cachedurationmillis'] = '300000'
default['rundeck']['ldap']['reportstatistics'] = true
default['rundeck']['ldap']['supplementalroles'] = node['rundeck']['default_role']

# Plugins
default['rundeck']['plugins']['slack']['url'] = 'https://github.com/higanworks/rundeck-slack-incoming-webhook-plugin/releases/download/v0.6.dev/rundeck-slack-incoming-webhook-plugin-0.6.jar'
default['rundeck']['plugins']['slack']['checksum'] = 'd23b31ec4791dff1a7051f1f012725f20a1e3e9f85f64a874115e46df77e00b5'
default['rundeck']['plugins']['winrm']['url'] = 'https://github.com/rundeck-plugins/rundeck-winrm-plugin/releases/download/v1.3.3/rundeck-winrm-plugin-1.3.3.jar'
default['rundeck']['plugins']['winrm']['checksum'] = 'dac57210e7a782d574621d5df27517bed4f58ebb54a40b9adab435333a5a5133'
