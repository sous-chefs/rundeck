default[:rundeck] = {}
default[:rundeck][:configdir] = "/etc/rundeck"
default[:rundeck][:basedir] = "/var/rundeck"
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

#The ssh key is going to be pulled from a databag named authorization, but you can choose
#what databag item to use.  Default is the chef environment, but you can change this to
#anything you want
default[:rundeck][:ssh][:databag_item] = "node.chef_environment"