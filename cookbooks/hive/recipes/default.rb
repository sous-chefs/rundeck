#
# Cookbook Name:: hive
# Recipe:: default
# Author:: Sean McNamara(<sean.mcnamara@webtrends.com>)
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
# This recipe installs the CAM IIS app

include_recipe "hadoop"

# define easier to use variables
tarball     = node['hive']['tarball']
download_url = node['hive']['download_url']

# determine metastore jdbc properties
metastore_prefix = "none"
metastore_driver = "none"

if node[:hive][:metastore][:connector] == "mysql"
  metastore_prefix = "mysql"
  metastore_driver = "com.mysql.jdbc.Driver"
end

if node[:hive][:metastore][:connector] == "sqlserver"
  metastore_prefix = "sqlserver"
  metastore_driver = "com.microsoft.sqlserver.jdbc.SQLServerDriver"
end

# download hive
remote_file "#{Chef::Config[:file_cache_path]}/#{tarball}" do
  source "#{download_url}#{tarball}"
  mode 00644
  not_if "test -f #{Chef::Config[:file_cache_path]}/#{tarball}"
end

# extract it
execute "extract-hive" do
  command "tar -zxf #{Chef::Config[:file_cache_path]}/#{tarball}"
  creates "hive-#{node[:hbase][:version]}"
  cwd "#{node[:hadoop][:install_stage_dir]}"
  user "hadoop"
  group "hadoop"
end

link "/usr/local/hive" do
  to "#{node[:hadoop][:install_stage_dir]}/hive-#{node[:hive][:version]}-bin"
end


# jdbc connectors
%w[mysql-connector-java.jar sqljdbc4.jar].each do |jar|
  cookbook_file "/usr/local/hive/lib/#{jar}" do
    source "#{jar}"
    owner "hadoop"
    group "hadoop"
    mode 00644
  end
end

# load the databag to get the hive meta db authentication
auth_config = data_bag_item('authorization', "#{node.chef_environment}")

# create config files and the startup script from template
%w[hive-site.xml hive-env.sh hive-exec-log4j.properties hive-log4j.properties].each do |template_file|
  template "/usr/local/hive/conf/#{template_file}" do
    source "#{template_file}"
    mode 00755
    variables(
      :metastore_driver => metastore_driver,
      :dbuser => auth_config["hive"]["dbuser"],
      :dbpass => auth_config["hive"]["dbpass"]
    )
  end

  # remove default template files
  file "/usr/local/hive/conf/#{template_file}.template" do
    action :delete
  end
end


# remove old jars
%w[hbase-0.89.0-SNAPSHOT.jar hbase-0.89.0-SNAPSHOT-tests.jar].each do |template_file|
  file "/usr/local/hive/lib/#{template_file}" do
    action :delete
  end
end

link "/usr/local/hive/lib/hbase-0.92.0.jar" do
  to "/usr/local/hbase/hbase-0.92.0.jar"
end