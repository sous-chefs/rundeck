server_install
===

Use the **server_install** resource to install and configure the Rundeck service.

Syntax
------

The full syntax for all of the properties available to the **server_install** resource is:

****
```ruby
server_install 'rundeck' do
  acl_policies                  Hash # Hash of ACL policies
  admin_password                String 
  basedir                       String # Rundeck installation directory, default '/var/lib/rundeck'
  chef_url                      String # Chef Server API URL, default 'https://chef.hostdomain.com'
  configdir                     String # Configuration directory, default '/etc/rundeck'
  custom_framework_config       Hash # Custom framework.properties options
  custom_jvm_properties         String # Custom jvm properties.
  custom_rundeck_config         Hash # Custom rundeck-config.properties options
  datadir                       String # Rundeck project directory, default '/var/rundeck'
  exec_logdir                   String # Directory where rundeck stores execution logs. Deafult is "#{node['rundeck']['basedir']}/logs"
  extra_wait                    Integer # Additional wait time after starting service before finishing.
  framework_properties          Hash # Use to set additional config in the framework.properties template
  grails_port                   Integer # The port to be used as part of the rundeck url in grails.
  grails_server_url             String # The URL of the rundeck server, default 'http://#{node['rundeck']['hostname']}#{node['rundeck']['webcontext']}', or 'https://#{node['rundeck']['hostname']}#{node['rundeck']['webcontext']}' if use_ssl is set.
  hostname                      String # VIP or server address for the service, default 'rundeck.hostdomain.com'
  jaas                          String #  Use built in internal realms.properties file, or a different one (options 'activedirectory', default 'internal')
  jvm_mem                       String # JVM memory arguments, default '-XX:MaxPermSize=256m -Xmx1024m -Xms256m'
  rundeckgroup                  String # Group to add the rundeckuser
  rundeckuser                   String # User to run Rundeck
  ldap_provider                 String # LDAP server for connection
  ldap_binddn                   String # LDAP root bind DN. It will be ignored if node['rundeck']['ldap']['forcebindinglogin'] is true
  ldap_bindpwd                  String # LDAP root bind password. It will be ignored if node['rundeck']['ldap']['forcebindinglogin'] is true
  ldap_authenticationmethod     String # LDAP authentication method
  ldap_forcebindinglogin        String # If true, bind as the user is authenticating, if not it bind using the root DN and perform a search to verify the user password
  ldap_userbasedn               String # LDAP base user DN search
  ldap_userrdnattribute         String # LDAP attribute name for user name
  ldap_useridattribute          String # LDAP attribute name to identify user
  ldap_userpasswordattribute    String # LDAP attribute name for user password
  ldap_userobjectclass          String # LDAP object class for user
  ldap_rolebasedn               String # LDAP base role DN search
  ldap_rolenameattribute        String # LDAP attribute name for role name
  ldap_rolememberattribute      String # LDAP attribute name that would contain the users DN
  ldap_roleobjectclass          String # LDAP object class for group
  ldap_roleprefix               String # Prefix string to remove from role names before returning to the application
  ldap_cachedurationmillis      String # Duration in milliseconds of the cache of an authorization
  ldap_reportstatistics         String # If true, output cache statistics to the log
  log_level                     %w(ERR WARN INFO VERBOSE DEBUG) # Debug level for rundeck (ERR,WARN,INFO,VERBOSE,DEBUG), default INFO
  mail_email                    String # Email address, default 'rundeck@hostdomain.com'
  mail_enable                   [true, false] # Enable mail
  mail_host                     String # SMTP host
  mail_password                 String # SMTP user password
  mail_port                     String # SMTP port
  mail_user                     String # SMTP user
  port                          Integer # Internal server port for the service, default '4440'
  private_key                   String # Private key to use for ssh.
  quartz_threadPoolCount        Integer #  Quartz job threadCount. The maximum number of threads used by Rundeck for concurrent jobs by default is set to 10.
  rdbms_dbname                  String # database name, default 'rundeckdb'
  rdbms_dialect                 String # hibernate database dialect, default 'Oracle10gDialect' 
  rdbms_enable                  [true, false] # enable RDBMS support, default false
  rdbms_location                String # RDBMS server name
  rdbms_password                String # database password
  rdbms_port                    Integer # database port number, default '3306'
  rdbms_type                    %w(mysql oracle) #  database type, default 'mysql'
  rdbms_user                    String # database username, default 'rundeckdb'
  restart_on_config_change      [true, false] # When true, rundeck will restart on any configuration file change. (even if a job is running) default 'false'
  rss_enabled                   [true, false] #  true/false for RSS support
  rundeck_users                 Hash # Local Rundeck users
  security_roles                Hash # Array containing additional security roles for which Rundeck will attempt to validate membership. For an explanation of this, see the Rundeck documentation.
  session_timeout               Integer # Number of minutes a rundeck session will last, before having to login again, default '30'
  ssl_port                      Integer # Use while using inbuilt SSL. Default 4443
  setup_repo                    [true, false] # Whether to setup a public repo.
  tempdir                       String # Rundeck temporary directory
  tokens_file                   String # File containing user API tokens (e.g. '/etc/rundeck/tokens.properties'), default is nil (not set)
  truststore_type               String
  use_inbuilt_ssl               [true, false] # Whether to use inbuilt SSL
  use_ssl                       [true, false] # Whether to use SSL
  uuid                          String
  version                       String # Version of Rundeck to install
  webcontext                    String # The URI portion of the rundeck server, default '/', you can set it to '/rundeck' if your webserver is handling other tasks besides rundeck.
end
```

Actions
-------

`:install`

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Install the Rundeck service. This is the only, and default, action.

Examples
--------

**Install the Rundeck service with defaults**

```ruby
server_install 'Rundeck' do
  action :install
end
```