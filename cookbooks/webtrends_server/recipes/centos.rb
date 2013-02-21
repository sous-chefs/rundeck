#
# Author:: Tim Smith(<tim.smith@webtrends.com>)
# Cookbook Name:: webtrends_server
# Recipe:: centos
#
# Copyright 2012, Webtrends Inc.
#
# All rights reserved - Do Not Redistribute
#

#Make sure that this recipe only runs on ubuntu systems
if not platform?("centos")
  Chef::Log.info("CentOS required for the CentOS recipe.")
  return
end

#Save the node to prevent empty run lists on failures
unless Chef::Config['solo']
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

#Fix the host file as CentOS ships with a bad hostfile
include_recipe "hosts"

# setup the client.rb file for chef with the correct chef server URL and logging options
if node['virtualization']['system'] != 'openstack'
  if node['chef_client']['server_url'].nil?
    Chef::Application.fatal!("Your environment must contain a valid [:chef_client][:server_url] value to run the webtrends_server cookbook")
  end
  include_recipe "chef-client::config"
end

# set chef-client to run on a regular schedule (30 mins)
include_recipe "chef-client::service"

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
node['webtrends_server']['yum'].each do |yumrepo|
  yum_repository yumrepo['name'] do
    repo_name yumrepo['name']
    description yumrepo['description']
    url yumrepo['url']
    action :add
  end
end

#Setup NRPE to run sudo w/o a password
file "/etc/sudoers.d/nagios" do
  owner "root"
  group "root"
  mode 00440
  content "nagios  ALL=NOPASSWD: ALL"
  action :create
end

# install nagios from package only
if node['nagios']['client']['install_method']
  include_recipe "nagios::client"
else
  log "skipping nagios::client because package install was not set in the environment"
end

# Sets up rundeck private keys
include_recipe "rundeck"

# installs vim
include_recipe "vim"

# installs man pages
include_recipe "man"

# installs various network tools
include_recipe "networking_basic"

# install useful tools
%w{ mtr strace iotop screen }.each do |pkg|
  package pkg
end

# Disable iptables firewall
service "iptables" do
  action :stop
  action :disable
end

#fprintd crashes every time someone tries to sudo.  Uninstall it
%w{ fprintd libfprint }.each do |pkg|
  package pkg
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
    home "/home/#{auth_config['alternate_user']}"
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
    content "%netiqdmz\\\\devAccess  ALL=(ALL) ALL\n"
    action :create
  end
else
  # Make sure the sudo file is gone if the system is not an EA system
  file "/etc/sudoers.d/devAccess" do
    action :delete
  end
end

# Create the sudoers file to allow for passwordless sudo with chef-client
#file "/etc/sudoers.d/devAccess" do
#  owner "root"
#  group "root"
#  mode 00440
#  content "%#{node['webtrend_server']['passwordless_sudo_chef_group']}-  ALL=(ALL) ALL\n"
#  action :create
#end

#Now that the local user is created attach the system to AD
include_recipe "ad-auth"

#Allow for hardware monitoring (CentOS in prod is always on hardware systems)
include_recipe "snmp"

#HP Systems only: Install HP System Management Homepage along with other HP tools.
include_recipe "hp-tools"

#Dell Systems only: Install Dell System E-Support Tool and Dell RAID tools
include_recipe "delltools::default"
include_recipe "delltools::dset"
include_recipe "delltools::raid"

#VMware Systems only: Install VMware tools
include_recipe "vmware-tools"

#Install collectd - system statistics collection daemon
include_recipe "collectd"

#Install collectd plugins for WT base OS monitoring
include_recipe "wt_monitoring::collectd_base"

#Sets up internal gem repo
if node['wt_common']['gem_repo']
  execute "remove rubygems" do
    command "gem source -r http://rubygems.org/"
    only_if "gem source | grep http://rubygems.org"
  end
  
  execute "gem_repo_add" do
    command "gem source -a #{node['wt_common']['gem_repo']}"
    not_if "gem source | grep #{node['wt_common']['gem_repo']}"
  end
end

#Installs gem for reporting to chef jabber server
chef_gem "chef-jabber-snitch"

#Install tmux - a terminal multiplexer
include_recipe "tmux"