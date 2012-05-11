#
# Cookbook Name:: wt_monitoring
# Recipe:: opsmon_scheduledhits
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
#
# This recipe is used to add base collectd plugins to all webtrends servers with collectd installed.
#

%w(collectd_WT-Base collectd_Graphite-Write).each do |file|
  template "#{node[:collectd][:plugin_conf_dir]}/#{file}.conf" do
    source "/collectd_base/#{file}.conf.erb"
    owner "root"
    group "root"
    mode 00644
    notifies :restart, resources(:service => "collectd")
  end
end

