#
# Cookbook Name:: cassandra
# Recipe:: required_packages
#
# Copyright 2011, DataStax
#
# Apache License
#

###################################################
# 
# Install the Required Packages
# 
###################################################

case node[:platform]
  when "ubuntu", "debian"
    # Ensure all native components are up to date
    # execute 'sudo apt-get -y upgrade'

    # Allow for non-interactive Sun Java setup
    execute 'echo "sun-java6-bin shared/accepted-sun-dlj-v1-1 boolean true" | sudo debconf-set-selections'
    package "sun-java6-jdk"

    # Uninstall other Java Versions
    execute 'sudo update-alternatives --set java /usr/lib/jvm/java-6-sun/jre/bin/java'
    package "openjdk-6-jre-headless" do
      action :remove
    end
    package "openjdk-6-jre-lib" do
      action :remove
    end
    
  when "centos", "redhat", "fedora"
    # Ensure all native components are up to date
    execute 'sudo yum -y update'
    # execute 'sudo yum -y upgrade'
end
