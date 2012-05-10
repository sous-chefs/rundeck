#
# Author:: David Dvorak (<david.dvorak@webtrends.com>)
# Cookbook Name:: wt_example
# Recipe:: default
#
# Copyright 2012, Webtrends Inc.
#
# All rights reserved - Do Not Redistribute
#

return unless deploy_mode?

this_msifile = get_build cb_config['msifile']

# create install log dir
directory wt_config['installlog_dir'] do
	:create
end

# create install dir
directory wt_config['install_dir'] do
	:create
end

# set ntfs perms
wt_base_icacls wt_config['install_dir'] do
	action :grant
	user wt_config['ui_user']
	perm :modify
end

# run msiexec or do other install steps
windows_package cb_config['display_name'] do
	source this_msifile
	options
	action :install
end

# share install folder
share_wrs

# update pod details

