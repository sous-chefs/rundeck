#
# Author:: Josh Behrends <josh.behrends@webtrends.com>
# Cookbook Name:: wt_monitoring
# Recipe:: base_nrpe_checks
#
# Copyright 2013, Webtrends
#
# All rights reserved - Do Not Redistribute
#
# This recipe lays down the base NRPE checks and adds any custom plugins that WT has in addition 


#Only create the following NRPE command definitions IF nagios has been applied to this box
if node.attribute?("nagios")
  #Create a nagios nrpe check 
  nagios_nrpecheck "check_all_disks" do
    command "#{node['nagios']['plugin_dir']}/check_disk"
    parameters "-w 8% -c 5% -A -x /dev/shm -X nfs -i /boot"
    action :add
  end 
  #Create a nagios nrpe check 
  nagios_nrpecheck "wt_check_disk" do
    command "#{node['nagios']['plugin_dir']}/check_disk"
    parameters "$ARG1$"
    action :add
  end 
  #Create a nagios nrpe check 
  nagios_nrpecheck "wt_check_file_age" do
    command "sudo #{node['nagios']['plugin_dir']}/check_file_age"
    parameters "$ARG1$"
    action :add
  end
  #Create a nagios nrpe check 
  nagios_nrpecheck "wt_check_file_ages_in_dirs" do
    command "sudo #{node['nagios']['plugin_dir']}/check_file_ages_in_dirs"
    parameters "$ARG1$"
    action :add
  end
  #Create a nagios nrpe check 
  nagios_nrpecheck "wt_check_file_size" do
    command "sudo #{node['nagios']['plugin_dir']}/check_file_size"
    parameters "$ARG1$"
    action :add
  end
  #Create a nagios nrpe check 
  nagios_nrpecheck "wt_check_ftp" do
    command "sudo #{node['nagios']['plugin_dir']}/check_ftp"
    parameters "$ARG1$"
    action :add
  end  
  #Create a nagios nrpe check 
  nagios_nrpecheck "wt_check_hpasm" do
    command "#{node['nagios']['plugin_dir']}/check_hpasm"
    parameters "$ARG1$"
    action :add
  end
  #Create a nagios nrpe check 
  nagios_nrpecheck "wt_check_http" do
    command "#{node['nagios']['plugin_dir']}/check_http"
    parameters "$ARG1$"
    action :add
  end
  #Create a nagios nrpe check 
  nagios_nrpecheck "wt_check_jmx" do
    command "#{node['nagios']['plugin_dir']}/check_jmx"
    parameters "$ARG1$"
    action :add
  end
  #Create a nagios nrpe check 
  nagios_nrpecheck "wt_check_jps" do
    command "#{node['nagios']['plugin_dir']}/check_jps_procs"
    parameters "$ARG1$"
    action :add
  end
  #Create a nagios nrpe check
  nagios_nrpecheck "wt_check_log" do
    command "sudo #{node['nagios']['plugin_dir']}/check_log"
    parameters "$ARG1$"
    action :add
  end
  #Create a nagios nrpe check 
  nagios_nrpecheck "wt_check_memcached_conns" do
    command "#{node['nagios']['plugin_dir']}/check_memcached_connections"
    parameters "$ARG1$"
    action :add
  end
  #Create a nagios nrpe check 
  nagios_nrpecheck "wt_check_procs" do
    command "#{node['nagios']['plugin_dir']}/check_procs"
    parameters "$ARG1$"
    action :add
  end
  #Create a nagios nrpe check 
  nagios_nrpecheck "wt_check_smart_disks" do
    command "sudo #{node['nagios']['plugin_dir']}/check_smartmon"
    parameters "$ARG1$"
    action :add
  end
  #Create a nagios nrpe check 
  nagios_nrpecheck "wt_check_ssh" do
    command "sudo #{node['nagios']['plugin_dir']}/check_ssh"
    parameters "$ARG1$"
    action :add
  end
  #Create a nagios nrpe check 
  nagios_nrpecheck "wt_check_swap" do
    command "#{node['nagios']['plugin_dir']}/check_swap"
    parameters "$ARG1$"
    action :add
  end
  #Create a nagios nrpe check 
  nagios_nrpecheck "wt_check_system_info" do
    command "#{node['nagios']['plugin_dir']}/check_system_info"
    action :add
  end
  #Create a nagios nrpe check 
  nagios_nrpecheck "wt_check_tcp" do
    command "#{node['nagios']['plugin_dir']}/check_tcp"
    parameters "$ARG1$"
    action :add
  end
  #Create a nagios nrpe check 
  nagios_nrpecheck "wt_check_updates" do
    command "sudo #{node['nagios']['plugin_dir']}/check_system_updates"
    action :add
  end
  
  #Copy extra NRPE plugins that are not packaged.
  remote_directory "#{node['nagios']['plugin_dir']}" do
    source "nrpe_plugins"
    owner "root"
    group "root"
    mode 00755
    files_mode 00755
  end
end
