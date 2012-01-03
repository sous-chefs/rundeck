#
# Cookbook Name:: cassandra
# Recipe:: install
#
# Copyright 2011, DataStax
#
# Apache License
#

###################################################
# 
# Install Cassandra
# 
###################################################

# Used to clear any system information that may have
# been created when the service autostarts
execute "clear-data" do
  command "rm -rf /var/lib/cassandra/data/system"
  action :nothing
end

# Sets up a user to own the data directories
node[:internal][:package_user] = "cassandra"

# Installs the latest Cassandra 0.7.x
if node[:setup][:deployment] == "07x"
  package "cassandra" do
    notifies :stop, resources(:service => "cassandra"), :immediately
    notifies :run, resources(:execute => "clear-data"), :immediately
  end
end

# Installs the latest Cassandra 0.8.x
if node[:setup][:deployment] == "08x"
  case node[:platform]
    when "ubuntu", "debian"
      package "cassandra" do
        notifies :stop, resources(:service => "cassandra"), :immediately
        notifies :run, resources(:execute => "clear-data"), :immediately
      end
    when "centos", "redhat", "fedora"
      package "cassandra08" do
        notifies :stop, resources(:service => "cassandra08"), :immediately
        notifies :run, resources(:execute => "clear-data"), :immediately
      end
  end
end
