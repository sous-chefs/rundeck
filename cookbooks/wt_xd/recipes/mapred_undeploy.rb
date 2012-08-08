#
# Cookbook Name:: wt_xd
# Recipe:: mapred_undeploy
#
# Copyright 2012, Webtrends Inc.
#
# All rights reserved - Do Not Redistribute
#

# destinations
install_dir = File.join(node['wt_common']['install_dir_linux'], 'wt_xd')
log_dir     = node['wt_common']['log_dir_linux']

%w[MapReduceFB MapReduceTW].each do |job|
	cron job do
		user 'webtrends'
		action :delete
	end
end

# delete install directory (keep log dir)
directory install_dir do
	recursive true
	action :delete
end

