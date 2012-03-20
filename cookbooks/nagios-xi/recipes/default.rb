#
# Cookbook Name:: nagios-xi
# Recipe:: default
#
# Copyright 2012, Webtrends Inc
#
# All rights reserved - Do Not Redistribute
#

#Install the prereqs for Nagios XI
package "procmail" do
  action :install
end

package "php-ldap" do
  action :install
end
