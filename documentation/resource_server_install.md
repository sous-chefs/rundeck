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
  basedir                       String
  chef_url                      String
  configdir                     String
  custom_framework_config       Hash
  custom_jvm_properties         String
  custom_rundeck_config         Hash
  datadir                       String
  exec_logdir                   String
  extra_wait                    Integer
  framework_properties          Hash
  grails_port                   Integer
  grails_server_url             String
  hostname                      String
  jaas                          String
  jvm_mem                       String
  rundeckgroup                  String
  rundeckuser                   String
  ldap_debug
  ldap_provider                 String
  ldap_binddn                   String
  ldap_bindpwd                  String
  ldap_authenticationmethod     String
  ldap_forcebindinglogin        String
  ldap_userbasedn               String
  ldap_userrdnattribute         String
  ldap_useridattribute          String
  ldap_userpasswordattribute    String
  ldap_userobjectclass          String
  ldap_rolebasedn               String
  ldap_rolenameattribute        String
  ldap_rolememberattribute      String
  ldap_roleobjectclass          String
  ldap_roleprefix               String
  ldap_cachedurationmillis      String
  ldap_reportstatistics         String
  log_level                     %w(ERR WARN INFO VERBOSE DEBUG)
  mail_email                    String
  mail_enable                   [true, false]
  mail_host                     String
  mail_password                 String
  mail_port                     String
  mail_user                     String
  plugins                       Hash
  port                          Integer
  private_key                   String
  quartz_threadPoolCount        Integer
  rdbms_dbname                  String
  rdbms_dialect                 String
  rdbms_dialect                 String
  rdbms_enable                  [true, false]
  rdbms_location                String
  rdbms_password                String
  rdbms_port                    Integer
  rdbms_type                    %w(mysql oracle)
  rdbms_user                    String
  restart_on_config_change      [true, false]
  rss_enabled                   [true, false]
  rundeckgroup                  String
  rundeckuser                   String
  rundeck_users                 Hash
  security_roles                Hash
  service_retries               Integer
  service_retry_delay           Integer
  session_timeout               Integer
  ssl_port                      Integer
  setup_repo                    [true, false]
  tempdir                       String
  tokens_file                   String
  truststore_type               String
  use_inbuilt_ssl               [true, false]
  use_ssl                       [true, false]
  uuid                          String
  version                       String
  webcontext                    String
  windows_winrm_auth_type       String
  windows_winrm_cert_trust      String
  windows_winrm_hostname_trust  String
  windows_winrm_protocol        String
  windows_winrm_timeout         String
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