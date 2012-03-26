default[:rundeck] = {}
default[:rundeck][:configdir] = "/etc/rundeck"
default[:rundeck][:basedir] = "/var/rundeck"
default[:rundeck][:deb] = "rundeck-1.3.0-2.deb"
default[:rundeck][:user] = "rundeck"
default[:rundeck][:user_home] = "/home/rundeck"
default[:rundeck][:chef_config] = "/etc/chef/rundeck.rb"
default[:rundeck][:chef_rundeck_url] = "http://chef.#{node[:domain]}:9980"
default[:rundeck][:chef_webui_url] = "http://chef.#{node[:domain]}:4040"
default[:rundeck][:chef_url] = "http://chef.#{node[:domain]}:4000"
default[:rundeck][:project_config] = "/etc/chef/chef-rundeck.json"

default[:rundeck][:jaas] = "internal"

#LDAP Properties
default[:rundeck][:ldap][:provider] = "ldap://seadc01.webtrends.corp:389"
default[:rundeck][:ldap][:binddn] = "CN=winbind,ou=serviceaccountsOLD,ou=WebTrendsUsers,dc=webtrends,dc=corp"
default[:rundeck][:ldap][:bindpwd] = "P1eas3Jo1nM3"
default[:rundeck][:ldap][:userbasedn] = "ou=WebTrendsUsers,dc=webtrends,dc=corp"
default[:rundeck][:ldap][:rolebasedn] = "ou=Security,ou=Groups,dc=webtrends,dc=corp"
