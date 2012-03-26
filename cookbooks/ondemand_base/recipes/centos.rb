#
# Author:: Tim Smith(<tim.smith@webtrends.com>)
# Cookbook Name:: ondemand_base
# Recipe:: centos
#
# Copyright 2012, Webtrends Inc.
#
# All rights reserved - Do Not Redistribute
#

#Make sure that this recipe only runs on ubuntu systems
if not platform?("centos")
	Chef::Log.info("Platform CentOS required.")
	return
end

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
	Chef::Log.info("Set a Chef environment. We don't want to use _default")
	exit(true)
end

#Fix the host file
include_recipe "hosts"

#Set chef-client to run on a regular schedule (30 mins)
include_recipe "chef-client"

# configures selinux enforcement policy
include_recipe "selinux::permissive"

# installs the EPEL repository
include_recipe "yum::epel"

# configures /etc/sudoers
include_recipe "sudo"

# installs and enables sshd service
include_recipe "openssh"

# installs, configures and enables ntp
include_recipe "ntp"

# configures /etc/resolv.conf
include_recipe "resolver"

#Add the Webtrends Yum repo
node['ondemand_base']['yum'].each do |yumrepo|
	yum_repository yumrepo['name'] do
		repo_name yumrepo['name']
		description yumrepo['description']
		url yumrepo['url']
		action :add
	end
end

#Setup NRPE to run sudo w/o a password
file "/etc/sudoers.d/nrpe" do
  owner "root"
  group "root"
  mode "0440"
  content "nrpe       ALL=NOPASSWD: ALL"
  action :create
end

#include_recipe "nagios::client"

#User experience and tools recipes

# installs vim
include_recipe "vim"

# installs man pages
include_recipe "man"

# installs various network tools
include_recipe "networking_basic"

# install useful tools
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

#Allow for hardware monitoring (CentOS only goes on hardware systems)
include_recipe "snmp"

