#
# Cookbook Name:: cassandra
# Recipe:: default
#
# Copyright 2011, DataStax
#
# Apache License
#

###################################################
# 
# Public Variable Declarations
# 
###################################################

# Stop Cassandra if it is running.
# Different for Debian due to service package.
if node[:platform] == "debian"
  service "cassandra" do
    action :stop
    ignore_failure true
  end
else
  service "cassandra" do
    action :stop
  end
end

# Only for debug purposes
OPTIONAL_INSTALL = true





include_recipe "cassandra::setup_repos"


include_recipe "cassandra::required_packages"


if OPTIONAL_INSTALL
  include_recipe "cassandra::optional_packages"
end


include_recipe "cassandra::install"


# include_recipe "cassandra::raid"


include_recipe "cassandra::additional_settings"


include_recipe "cassandra::token_generation"


include_recipe "cassandra::create_seed_list"


include_recipe "cassandra::write_configs"


include_recipe "cassandra::restart_service"
