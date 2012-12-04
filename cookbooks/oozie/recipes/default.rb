#
# Cookbook Name:: oozie
# Recipe:: default
# Author:: Robert Towne(<robert.towne@webtrends.com>)
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
# this recipe installs oozie


#include_recipe 'hadoop' version for ubuntu


# define easier to use variables
source_tarball  = node.oozie_attrib(:download_url)[/\/([^\/\?]+)(\?.*)?$/, 1]
source_fullpath = File.join(Chef::Config[:file_cache_path], source_tarball)

# determine metastore jdbc properties
metastore_prefix = 'none'
metastore_driver = 'none'

if node.oozie_attrib(:metastore, :connector) == 'mysql'
	metastore_prefix = 'mysql'
	metastore_driver = 'com.mysql.jdbc.Driver'
end

if node.oozie_attrib(:metastore, :connector) == 'sqlserver'
	metastore_prefix = 'sqlserver'
	metastore_driver = 'com.microsoft.sqlserver.jdbc.SQLServerDriver'
end

# download oozie
remote_file source_fullpath do
	source node.oozie_attrib(:download_url)
	mode 00644
	not_if "test -f #{source_fullpath}"
end

# extract it
execute 'extract-oozie' do
	command "tar -zxf #{source_fullpath}"
	creates "oozie-#{node.oozie_attrib(:version)}-bin"
	cwd "#{node.hadoop_attrib(:install_dir)}"
	user 'hadoop'
	group 'hadoop'
end

link '/usr/share/oozie' do
	to "#{node.hadoop_attrib(:install_dir)}/oozie-#{node.oozie_attrib(:version)}-bin"
end

# jdbc connectors
%w[mysql-connector-java.jar sqljdbc4.jar].each do |jar|
	cookbook_file "/usr/share/oozie/lib/#{jar}" do
		source "#{jar}"
		owner 'hadoop'
		group 'hadoop'
		mode 00644
	end
end

# load the databag to get the oozie meta db authentication
auth_config = data_bag_item('authorization', "#{node.chef_environment}")

# create the log directory
directory '/var/log/oozie' do
	action :create
	owner 'hadoop'
	group 'hadoop'
	mode 00755
end

# create config files and the startup script from template
%w[oozie-env.sh].each do |template_file|
	template "/usr/share/oozie/conf/#{template_file}" do
		source "#{template_file}"
		mode 00755
		variables(
			:metastore_driver => metastore_driver,
			:dbuser => auth_config['oozie']['dbuser'],
			:dbpass => auth_config['oozie']['dbpass']
		)
	end

	# remove default template files
	file "/usr/share/oozie/conf/#{template_file}.template" do
		action :delete
	end
end


link "/usr/share/oozie/lib/hbase-#{node.hbase_attrib(:version)}.jar" do
	owner 'hadoop'
	group 'hadoop'
	to "/usr/share/hbase/hbase-#{node.hbase_attrib(:version)}.jar"
end


