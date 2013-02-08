#
# Cookbook Name:: wt_actioncenter
# Recipe:: default
# Author: Marcus Vincent(<marcus.vincent@webtrends.com>)
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
#
# This recipe installs the ActionCenter WebAPI IIS app
#
 
if ENV['deploy_build'] == 'true' then
  include_recipe 'ms_dotnet4::regiis'
  include_recipe 'wt_actioncenter::uninstall'
end
 
user_data = data_bag_item('authorization', node.chef_environment)

# locations
install_dir           = "#{node['wt_common']['install_dir_windows']}\\Webtrends.ActionCenter"
log_dir               = "#{node['wt_common']['install_dir_windows']}\\Webtrends.ActionCenter\\logs"
iis_action_center_dir = "#{node['wt_common']['install_dir_windows']}\\Webtrends.ActionCenter\\Webtrends.ActionCenterService"

# static content properties
static_content_version  = 'v1'
static_content_dest     = node['wt_actioncenter']['static_content_dest']

# iis 
app_pool  = node['wt_actioncenter']['app_pool']
http_port = node['wt_actioncenter']['port']
ui_user   = user_data['wt_common']['ui_user']
ui_pass   = user_data['wt_common']['ui_pass']

# rsa 
rsa_user       = user_data['wt_common']['ui_user']
googleplay_key = data_bag_item('rsa_keys', 'googleplay')

##
## BEGIN: Standard IIS Setup
##

# configure IIS
appcmds = Array.new

# set 4 hour content expiration to allow browser caching
# note: A10 includes this in the web.config so this may not be necessary on an A10 system
appcmds << "/section:staticContent /clientCache.cacheControlMode:UseMaxAge /clientCache.cacheControlMaxAge:04:00:00"

# enable compression of static & dynamic content
# note:  in IIS 7.5 the default value of the doStaticCompression and doDynamicCompression changed from false to true
appcmds << "/section:urlCompression /doStaticCompression:True"
appcmds << "/section:urlCompression /doDynamicCompression:True"

# enable deflate compression format compression
appcmds << "/section:httpCompression /+\"[name='deflate',doStaticCompression='True',doDynamicCompression='True',dll='%windir%\\system32\\inetsrv\\gzip.dll']\" /commit:apphost"

# set reasonable compression levels for deflate and gzip
appcmds << "/section:httpCompression \"-[name='gzip'].dynamicCompressionLevel:4\""
appcmds << "/section:httpCompression \"-[name='gzip'].staticCompressionLevel:9\""
appcmds << "/section:httpCompression \"-[name='deflate'].dynamicCompressionLevel:4\""
appcmds << "/section:httpCompression \"-[name='deflate'].staticCompressionLevel:9\""

# set IIS logging
appcmds << "/section:system.webServer/httpErrors /errorMode:Detailed"
appcmds << "/section:system.applicationHost/sites /siteDefaults.logfile.logExtFileFlags:\"BytesRecv,BytesSent,ClientIP,ComputerName,Cookie,Date,Host,HttpStatus,HttpSubStatus,Method,ProtocolVersion,Referer,ServerIP,ServerPort,SiteName,Time,TimeTaken,UriQuery,UriStem,UserAgent,UserName,Win32Status\""
appcmds << "/section:system.applicationHost/sites /siteDefaults.logfile.directory:\"#{node['wt_common']['install_dir_windows']}\\logs\""

appcmds.each do |thiscmd|
  iis_config "Webtrends IIS Configurations" do
    cfg_cmd thiscmd
    action :config
    returns [0, 183]
  end
end

# remove default web site
iis_site 'Default Web Site' do
  action [:stop, :delete]
end

# remove default app pool
iis_pool 'DefaultAppPool' do
  action [:stop, :delete]
end

##
## END: Standard IIS Setup
##
 
iis_pool app_pool do
  pipeline_mode :Integrated
  runtime_version '4.0'
  pool_username ui_user
  pool_password ui_pass
  action [:add, :config]
end
 
directory install_dir do
  recursive true
  action :create
  rights :write, ui_user
  rights :read,  ui_user
end
 
iis_site 'ActionCenter' do
  protocol :http
  port http_port
  application_pool app_pool
  path iis_action_center_dir 
  action [:add,:start]
  retries 2
end

wt_base_netlocalgroup 'Performance Monitor Users' do
  user ui_user
  returns [0, 2]
  action :add
end

if ENV['deploy_build'] == 'true' then

  windows_zipfile install_dir do
    source node['wt_actioncenter']['download_url']
    action :unzip
  end
 
  template "#{iis_action_center_dir}\\bin\\PublicPrivateKeys.rsa" do
    source 'PublicPrivateKeys.rsa.erb'
    variables(
      :modulus => googleplay_key['modulus'],
      :exponent => googleplay_key['exponent'],
      :p => googleplay_key['p'],
      :q => googleplay_key['q'],
      :dp => googleplay_key['dp'],
      :dq => googleplay_key['dq'],
      :inverse_q => googleplay_key['inverse_q'],
      :d => googleplay_key['d']
    )
  end

  # run iis command on the .rsa file  
   
  wt_base_icacls 'C:\\ProgramData\\Microsoft\\Crypto\\RSA\\MachineKeys' do
    user node['current_user']
    perm :modify
    action :grant
  end

  execute 'asp_regiis_pi' do   
    command  "C:\\Windows\\Microsoft.NET\\Framework64\\v4.0.30319\\aspnet_regiis -pi Webtrends.ActionCenter #{iis_action_center_dir}\\bin\\PublicPrivateKeys.rsa"
  end
 
  execute 'asp_regiis_pa' do
    command  "C:\\Windows\\Microsoft.NET\\Framework64\\v4.0.30319\\aspnet_regiis -pa Webtrends.ActionCenter #{rsa_user}"
  end

 # delete the .rsa file
  file "#{iis_action_center_dir}\\bin\\PublicPrivateKeys.rsa" do
    action :delete
  end
 
  wt_base_icacls 'C:\\ProgramData\\Microsoft\\Crypto\\RSA\\MachineKeys' do
    user node['current_user']
    perm :modify
    action :remove
  end

end

template "#{iis_action_center_dir}\\log4net.config" do
  source 'log4net.config.erb'
  variables(
    :log_level => node['wt_actioncenter']['log_level']
  )
end

template "#{iis_action_center_dir}\\web.config" do
  source 'web.config.erb'
  variables(    
    # master database host
    :master_host => node['wt_masterdb']['host'],     
    # cache config
    :cache_enabled => node['wt_actioncenter']['cache_enabled'],
    :cache_hosts   => node['memcached']['cache_hosts'],
    :cache_region  => node['wt_actioncenter']['cache_region'],
    # cassandra config
    :cass_host            => node['cassandra']['cassandra_host'],
    :cass_report_column   => node['cassandra']['cassandra_report_column'],
    :cass_metadata_column => node['cassandra']['cassandra_meta_column'],
    :cass_thrift_port     => node['cassandra']['cassandra_thrift_port'],
    # other settings
    :monitor_host            => node['wt_messaging_monitoring']['monitor_hostname'],
    :actioncenter_public_key => node['wt_actioncenter']['actioncenter_public_key'],
    :static_content_url      => File.join(node['wt_static_tag_host']['host'], static_content_version)
  )
end

directory log_dir do
  action :create
  rights :full_control, ui_user
end

directory "#{ENV['windir']}\\Temp" do
  rights :full_control, 'SYSTEM'
  rights :full_control, 'Administrators'
  rights :write, 'Users'
  rights :read, ui_user
end

share_wrs
