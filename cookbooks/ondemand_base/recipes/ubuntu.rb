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
	Chef::Log.info("Ubuntu required for the Ubuntu recipe.")
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

# Setup the Webtrends apt repo.  This has to be the first thing that happens
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

# updates apt cache
include_recipe "apt"

#Set chef-client to run on a regular schedule (30 mins)
include_recipe "chef-client"

# configures /etc/apt/sources.list
include_recipe "ubuntu"

# configures /etc/sudoers
include_recipe "sudo"

# installs and enables sshd service
include_recipe "openssh"

# installs, configures and enables ntp
include_recipe "ntp"

# configures /etc/resolv.conf
include_recipe "resolver"

#Setup NRPE to run sudo w/o a password
file "/etc/sudoers.d/nrpe" do
	owner "root"
	group "root"
	mode 00440
	content "nagios	ALL=NOPASSWD: ALL"
	action :create
end

# install nagios from package only
if node['nagios']['client']['install_method'] == "package" and node['nagios']['client']['skip_install'] !~ /^true$/i
	include_recipe "nagios::client"
else
	log "skipping nagios::client"
end

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

# create the webtrends service account and group
group "webtrends" do
  gid 1993
end

user "webtrends" do
  uid 1993
  gid "webtrends"
  shell "/bin/false"
  comment "Webtrends local service account"
  password "*"
end

# Create a sudoers file for devAccess group if the system has ea_server role
if node.run_list.include?("role[ea_server]")
	file "/etc/sudoers.d/devAccess" do
		owner "root"
		group "root"
		mode 00440
		content "netiqdmz\\\\devAccess	ALL=(ALL) ALL"
		action :create
	end
else
  # Make sure the sudo file is gone if the system is not an EA system
	file "/etc/sudoers.d/devAccess" do
		action :delete
	end
end

#Now that the local user is created attach the system to AD
include_recipe "ad-auth"

#Install VMware tools if no version is present
include_recipe "vmware-tools"

#Install collectd - system statistics collection daemon
include_recipe "collectd"

#Install collectd plugins for WT base OS monitoring
include_recipe "wt_monitoring::collectd_base"