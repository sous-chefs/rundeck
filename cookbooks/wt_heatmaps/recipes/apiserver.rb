#
# Cookbook Name:: wt_heatmaps
# Recipe:: apiserver
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
#

package "heatmaps" do
	version node['wt_heatmaps']['heatmaps_version']
	options "--force-yes"
	action :install
end

thriftservers = Array.new

# determine chef environment to search
search_environment = ( node['wt_heatmaps']['alt_chef_environment'].length >= 1 ) ? node['wt_heatmaps']['alt_chef_environment'] : node.chef_environment

# search for data nodes
search(:node, "role:hadoop_datanode AND chef_environment:#{search_environment}").each do |n|
	thriftservers << n['fqdn']
end

# throw error if none are found
if thriftservers.count == 0
	Chef::Application.fatal!("no data nodes found in chef environment: #{search_environment}")
end

template "/var/lib/php5/thriftservers.php" do
	source "apiserver/thriftservers.php.erb"
	owner "www-data"
	group "www-data"
	mode 00744
	variables(
		:thriftservers => thriftservers
	)
end

# setup webserver
template "#{node['nginx']['dir']}/sites-available/apiserver" do
	source "apiserver/apiserver.erb"
	owner "root"
	group "root"
	mode 00644
	notifies :restart, resources(:service => "nginx")
end

remote_directory "/var/www" do
	source "apiserver-www"
	owner "www-data"
	group "www-data"
	files_owner "www-data"
	files_group "www-data"
	files_mode 00744
	mode 00744
end

nginx_site "default" do
	enable false
end

nginx_site "apiserver" do
	enable true
	notifies :restart, resources("service[nginx]","service[php-fastcgi]")
end

if node.attribute?("nagios")
	#Create a nagios nrpe check for the healthcheck page
	nagios_nrpecheck "wt_heatmaps_url_check" do
		command "#{node['nagios']['plugin_dir']}/check_http"
		parameters "-H localhost -u \"/heatmap_meta.php?accountid=10314&w=1663&h=200&dot=60&filter=infrared&coef=1&startd=2012-05-31&stopd=2012-06-20&top=600&i=3&page=webtrends.com%3B42099b4af021e53fd8fd4e056c2568d7c2e3ffa8\" -p 80 -r \"y_max\""
		action :add
	end
end

#Create collectd plugin for nginx if collectd has been applied.
if node.attribute?("collectd")
	cookbook_file "#{node['collectd']['plugin_conf_dir']}/nginx.conf" do
		source "nginx.conf"
		owner "root"
		group "root"
		mode 00644
		notifies :restart, resources(:service => "collectd")
	end
end