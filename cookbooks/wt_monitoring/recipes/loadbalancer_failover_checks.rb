#
# Cookbook Name:: wt_monitoring
# Recipe:: loadbalancer_failover_checks
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
#
# This recipe is used to create NRPE definitions for snmp checks that detect when various LB failovers have taken place.
#

#First check to make sure the Nagios cookbook has been applied to this box before continuing.
if node.attribute?("nagios")
  #Check primary node in AMSLBA
  nagios_nrpecheck "wt_check_amslba_primary_node" do
    command "#{node['nagios']['plugin_dir']}/check_snmp"
    parameters "-H 10.92.0.30 -P 2c -C wtlive -o 1.3.6.1.4.1.5951.4.1.1.6.0 -c 1:1"
    action :add
  end
  #Check standby node in AMSLBA
  nagios_nrpecheck "wt_check_amslba_standby_node" do
    command "#{node['nagios']['plugin_dir']}/check_snmp"
    parameters "-H 10.92.0.31 -P 2c -C wtlive -o 1.3.6.1.4.1.5951.4.1.1.6.0 -c 2:2"
    action :add
  end
  #Check primary node in LASLBB
  nagios_nrpecheck "wt_check_laslbb_primary_node" do
    command "#{node['nagios']['plugin_dir']}/check_snmp"
    parameters "-H 10.88.0.160 -P 2c -C wtlive -o 1.3.6.1.4.1.5951.4.1.1.6.0 -c 1:1"
    action :add
  end
  #Check standby node in LASLBB
  nagios_nrpecheck "wt_check_laslbb_standby_node" do
    command "#{node['nagios']['plugin_dir']}/check_snmp"
    parameters "-H 10.88.0.161 -P 2c -C wtlive -o 1.3.6.1.4.1.5951.4.1.1.6.0 -c 2:2"
    action :add
  end
  #Check primary node in PDXLBB
  nagios_nrpecheck "wt_check_pdxlbb_primary_node" do
    command "#{node['nagios']['plugin_dir']}/check_snmp"
    parameters "-H 10.61.1.134 -P 2c -C wtlive -o 1.3.6.1.4.1.5951.4.1.1.6.0 -c 1:1"
    action :add
  end
  #Check standby node in PDXLBB
  nagios_nrpecheck "wt_check_pdxlbb_standby_node" do
    command "#{node['nagios']['plugin_dir']}/check_snmp"
    parameters "-H 10.61.1.135 -P 2c -C wtlive -o 1.3.6.1.4.1.5951.4.1.1.6.0 -c 2:2"
    action :add
  end
end
