#
# Author:: David Dvorak (<david.dvorak@webtrends.com>)
# Cookbook Name:: cassandra
# Recipe:: default
#
# Copyright 2012, Webtrends Inc.
#
# All rights reserved - Do Not Redistribute
#

# Install the package.
package "apache-cassandra1" do
  action :install
  version node['cassandra']['version']
end

# Drop the JNA Jar.
bash "installJNA" do
user "root"
  code <<-EOH
  if [ ! -e /usr/share/cassandra/lib/jna.jar ]; then
    wget #{node['cassandra']['jna_url']} -O /usr/share/cassandra/lib/jna.jar
    chown cassandra /usr/share/cassandra/lib/jna.jar
    chmod 755 /usr/share/cassandra/lib/jna.jar
  fi
  EOH
end

# Drop MX4J jar.
bash "installMX4J" do
user "root"
  cwd "#{Chef::Config[:file_cache_path]}"
  code <<-EOH
  if [ ! -e /usr/share/cassandra/lib/mx4j-tools.jar ]; then
    wget #{node['cassandra']['mx4j_url']}
    tar zxvf mx4j-3.0.2.tar.gz mx4j-3.0.2/lib/mx4j-tools.jar
    cp mx4j-3.0.2/lib/mx4j-tools.jar /usr/share/cassandra/lib/
    chown cassandra:cassandra /usr/share/cassandra/lib/mx4j-tools.jar
    chmod 755 /usr/share/cassandra/lib/mx4j-tools.jar
  fi
  EOH
end

# cassandra environment
template '/etc/cassandra/conf/cassandra-env.sh' do
  source 'cassandra-env.sh.erb'
  variables(
    :max_heap_size => node['cassandra']['max_heap_size'],
    :heap_newsize  => node['cassandra']['heap_newsize']
  )
  notifies :restart, 'service[cassandra]'
end

service 'cassandra' do
  supports :restart => true
  action :nothing
end

include_recipe "cassandra::monitors"
