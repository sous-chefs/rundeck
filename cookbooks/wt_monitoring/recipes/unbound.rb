#
# Cookbook Name:: wt_monitoring
# Recipe:: unbound
# Author:: David Dvorak <david.dvorak@webtrends.com>
#
# Copyright 2013, Webtrends Inc.
#
# All rights reserved - Do Not Redistribute
#

service 'collectd' do
	supports :restart => true
	action :nothing
end

# This is a kludge to fix the broken python module on precise.
# When the collectd package is updated, check to see if this still necessary.
link '/usr/lib/libpython2.6.so.1.0' do
	to '/usr/lib/libpython2.7.so.1.0'
end

# unbound plugin config
cookbook_file "#{node['collectd']['plugin_conf_dir']}/unbound-stats.conf" do
	source 'unbound/unbound-stats.conf'
	owner 'root'
	group 'root'
	mode 00644
	action :create
	notifies :restart, resources(:service => 'collectd')
end

# python plugin path
directory '/opt/monitor'

# unbound plugin
cookbook_file '/opt/monitor/unbound-stats.py' do
	source 'unbound/unbound-stats.py'
	owner 'root'
	group 'root'
	mode 00755
	action :create
	notifies :restart, resources(:service => 'collectd')
end

