#Make sure that this recipe only runs on ubuntu systems
if platform?("centos")

#Save the node to prevent empty run lists on failures
unless Chef::Config[:solo]
  ruby_block "save node data" do
    block do
      node.save
    end
    action :create
  end
end

#Make sure someone didn't set the _default environment
if node.chef_environment == "_default"
  Chef::Log.info("Set a Chef environment.  We dont want to use _default")
  exit(true)
end

#Fix the host file
include_recipe "hosts"

#Set chef-client to run on a regular schedule (30 mins)
include_recipe "chef-client"

#Base recipes necessary for a functioning system
include_recipe "selinux::permissive"
include_recipe "yum"
include_recipe "yum::epel"
include_recipe "sudo"
include_recipe "openssh"
include_recipe "ntp"
include_recipe "resolver"

#Add the Webtrends Yum repo
node['ondemand_server']['yum'].each do |yumrepo|
	yum_repository yumrepo['name'] do
		repo_name yumrepo['name']
		description yumrepo['description']
		url yumrepo['url']
		action :add
	end
end

#Monitoring
file "/etc/sudoers.d/nrpe" do
  owner "root"
  group "root"
  mode "0440"
  content "nrpe       ALL=NOPASSWD: ALL"
  action :create
end

#include_recipe "nagios::client"

#User experience and tools recipes
include_recipe "vim"
include_recipe "man"
include_recipe "networking_basic"

# Install useful tools
%w{ mtr strace iotop }.each do |pkg|
  package pkg
end

# Disable iptables firewall
service "iptables" do
  action :stop
  action :disable
end

# Used for password string generation
package "ruby-shadow"

#Pull authorization data from the authorization data bag
auth_config = data_bag_item('authorization', node.chef_environment)

# set root password from authorization databag
user "root" do
  password auth_config['root_password']
  shell "/bin/bash"
end

# add non-root user from authorization databag
if auth_config['alternate_user']
  user auth_config['alternate_user'] do
    password auth_config['alternate_pass']
    if auth_config['alternate_uid']
      uid auth_config['alternate_uid']
    end
    shell "/bin/bash"
    supports :manage_home => true
  end
end

#Now that the local user is created attach the system to AD
include_recipe "ad-auth"

#Setup monitoring
include_recipe "snmp"

end
