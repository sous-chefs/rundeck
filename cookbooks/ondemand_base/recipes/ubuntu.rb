#
# Author:: Tim Smith(<tim.smith@webtrends.com>)
# Cookbook Name:: ondemand_base
# Recipe:: ubuntu
#
# Copyright 2012, Webtrends Inc.
#
# All rights reserved - Do Not Redistribute
#

#Make sure that this recipe only runs on ubuntu systems
if not platform?("ubuntu")
	Chef::Log.info("Platform Ubuntu required.")
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

#Set chef-client to run on a regular schedule (30 mins)
include_recipe "chef-client"

# configures /etc/apt/sources.list
include_recipe "ubuntu"

# configures /etc/sudoers
include_recipe "sudo"

# updates apt cache
include_recipe "apt"

# installs and enables sshd service
include_recipe "openssh"

# installs, configures and enables ntp
include_recipe "ntp"

# configures /etc/resolv.conf
include_recipe "resolver"

# Setup the Webtrends apt repo
node['ondemand_base']['apt'].each do |aptrepo|
	apt_repository aptrepo['name'] do
		repo_name aptrepo['name']
		if aptrepo.has_key? "distribution"
			distribution aptrepo['distribution']
		elsif aptrepo.has_key? "distribution_suffix"
			distribution node[:lsb][:codename] + aptrepo['distribution_suffix']
		else 
			distribution node[:lsb][:codename]
		end
		uri aptrepo['url']
		components aptrepo['components']
		key aptrepo['key']
		action :add
	end
end

#Setup NRPE to run sudo w/o a password
file "/etc/sudoers.d/nrpe" do
	owner "root"
	group "root"
	mode "0440"
	content "nagios	ALL=NOPASSWD: ALL"
	action :create
end

include_recipe "nagios::client"

# Sets up runeck private keys
include_recipe "rundeck"

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

# Used for password string generation
package "libshadow-ruby1.8"

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

#Install likewise-open with a force-yes so it ignores the fact that the package isn't signed
package "likewise-open" do
  options "--force-yes"
  version "6.1.0-2"
  action :install
end

#Now that the local user is created attach the system to AD
include_recipe "ad-auth"

#Install VMware tools if no version is present
include_recipe "vmware-tools"
