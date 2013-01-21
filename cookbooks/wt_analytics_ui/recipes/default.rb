#
# Cookbook Name:: wt_analytics_ui
# Author:: Kendrick Martin(<kendrick.martin@webtrends.com>)
# Recipe:: default
#
# Copyright 2012, Webtrends Inc.
#
# All rights reserved - Do Not Redistribute
#

log "Deploy build is #{ENV["deploy_build"]}"
if ENV["deploy_build"] == "true" then
  log "The deploy_build value is true so un-deploy first"
  include_recipe "wt_analytics_ui::uninstall"
  include_recipe "ms_dotnet4::regiis"
else
  log "The deploy_build value is not set or is false so we will only update the configuration"
end

# properties
install_dir = File.join(node['wt_common']['install_dir_windows'], node['wt_analytics_ui']['install_dir']).gsub(/[\\\/]+/,"\\")
install_url = node['wt_analytics_ui']['download_url']

user_data = data_bag_item('authorization', node.chef_environment)
ui_user   = user_data['wt_common']['ui_user']
ui_pass   = user_data['wt_common']['ui_pass']
rsa_user = user_data['wt_common']['ui_user']
app_pool_name = node['wt_analytics_ui']['app_pool_name']
googleplay_key = data_bag_item('rsa_keys', 'googleplay')

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

# set IIS to allow just these extensions
extensions = [
  '.',
  '.asp',
  '.aspx',
  '.axd',
  '.css',
  '.eot',
  '.gif',
  '.htm',
  '.html',
  '.ico',
  '.jpeg',
  '.jpg',
  '.js',
  '.jslang',
  '.less',
  '.png',
  '.svg',
  '.tmpl',
  '.ttf',
  '.woff'
]

iis_config "/section:system.webServer/security/requestfiltering /fileExtensions.allowunlisted:false" do
  action :config
end

iis_config "/section:system.webServer/security/requestfiltering /fileExtensions.applyToWebDAV:false" do
  action :config
end

extensions.each do |ext|
  iis_config "Allow Extensions" do
    cfg_cmd "/section:system.webServer/security/requestFiltering \"/+fileExtensions.[fileExtension='#{ext}',allowed='true']\""
    action :config
    returns [0, 183]
  end
end

directory install_dir do
  action :create
  recursive true
end

iis_pool app_pool_name do
  pipeline_mode :Integrated
  runtime_version "4.0"
  private_mem node['wt_analytics_ui']['app_pool_private_memory']
  max_proc 1
  pool_username ui_user
  pool_password ui_pass
  action [:add, :config]
end

iis_site 'Analytics' do
  protocol :http
  port node['wt_analytics_ui']['website_port']
  path install_dir
  application_pool app_pool_name
  action [:add, :start]
end

wt_base_icacls install_dir do
  user ui_user
  perm :modify
  action :grant
end

wt_base_icacls install_dir do
  user "IUSR"
  perm :read
  action :grant
end

# resolves "Unable to obtain public key for StrongNameKeyPair" error
wt_base_icacls "C:\\ProgramData\\Microsoft\\Crypto\\RSA\\MachineKeys" do
  user ui_user
  perm :modify
  action :grant
end

wt_base_netlocalgroup "Performance Monitor Users" do
  user ui_user
  returns [0, 2]
  action :add
end

if ENV["deploy_build"] == "true" then

  windows_zipfile install_dir do
    source install_url
    action :unzip
  end

  template "#{install_dir}\\Web.config" do
    source "webConfig.erb"
     variables(
      # master database host
      :master_host => node['wt_masterdb']['host'],

      # cache config
      :cache_enabled => node['wt_analytics_ui']['cache_enabled'],
      :cache_hosts   => node['memcached']['cache_hosts'],
      :cache_region  => node['wt_analytics_ui']['cache_region'],

      # hbase config
      :hbase_location    => node['hbase']['location'],
      :hbase_dc_id       => node['wt_analytics_ui']['fb_data_center_id'],
      :hbase_pod_id      => node['wt_common']['pod_id'],

      # cassandra config
      :cass_host            => node['cassandra']['cassandra_host'],
      :cass_report_column   => node['cassandra']['cassandra_report_column'],
      :cass_metadata_column => node['cassandra']['cassandra_meta_column'],
      :cass_thrift_port     => node['cassandra']['cassandra_thrift_port'],

      # app setting section
      :rest_base_uri           => node['wt_dx']['rest_base_uri'],
      :ondemand_base_domain    => node['wt_analytics_ui']['ondemand_base_domain'],
      :fb_app_clientid         => node['wt_analytics_ui']['fb_app_clientid'],
      :fb_app_clientsecret     => node['wt_analytics_ui']['fb_app_clientsecret'],
      :beta                    => node['wt_analytics_ui']['beta'],
      :branding                => node['wt_analytics_ui']['branding'],
      :ios_public_key      => node['wt_analytics_ui']['ios_public_key'],
      :facebook_public_key   => node['wt_analytics_ui']['facebook_public_key'],
      :android_public_key    => node['wt_analytics_ui']['android_public_key'],
      :youtube_public_key    => node['wt_analytics_ui']['youtube_public_key'],
      :twitter_public_key    => node['wt_analytics_ui']['twitter_public_key'],
      :tagbuilder_download_url => node['wt_analytics_ui']['tagbuilder_download_url'],
      :tagbuilder_url_template => node['wt_analytics_ui']['tagbuilder_url_template'],
      :tagbuilder_domain       => node['wt_analytics_ui']['tagbuilder_domain'],
      :tagbuilder_domainmobile => node['wt_analytics_ui']['tagbuilder_domainmobile'],
      :help_link               => node['wt_analytics_ui']['help_link'],
      :hmap_url                => node['wt_analytics_ui']['hmap_url'],
      :reinvigorate_code       => node['wt_analytics_ui']['reinvigorate_tracking_code'],
      :show_profiling          => node['wt_analytics_ui']['show_profiling'],

      # proxy
      :proxy_enabled => node['wt_analytics_ui']['proxy_enabled'],
      :proxy_address => node['wt_analytics_ui']['proxy_address'],

      # other settings
      :custom_errors => node['wt_analytics_ui']['custom_errors'],
      :search_host   => node['wt_search']['search_hostname'],
      :monitor_host  => node['wt_messaging_monitoring']['monitor_hostname'],
      :remote_access => node['wt_analytics_ui']['remote_access'],
	  :pdf_export_url => node['wt_analytics_ui']['pdf_export_url']
    )
  end


  template "#{install_dir}\\bin\\PublicPrivateKeys.rsa" do
    source "PublicPrivateKeys.rsa.erb"
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

  template "#{install_dir}\\App_Data\\brands\\mapping.xml" do
    source "mapping.xml.erb"
    variables(
      :bba_domain => node['wt_analytics_ui']['bba_domain']
    )
  end

  template "#{install_dir}\\App_Data\\brands\\webtrends\\brand.xml" do
    source "webtrends-brand.xml.erb"
    variables(
      :help_link            => node['wt_analytics_ui']['help_link'],
      :ondemand_base_domain => node['wt_analytics_ui']['ondemand_base_domain']
    )
  end

  template "#{install_dir}\\log4net.config" do
    source "log4net.config.erb"
    variables(
      :log_level => node['wt_analytics_ui']['log_level']
    )
  end

  # run iss command on the .rsa file  

  wt_base_icacls "C:\\ProgramData\\Microsoft\\Crypto\\RSA\\MachineKeys" do
  user node['current_user']
  perm :modify
  action :grant
end

  execute "asp_regiis_pi" do   
    command  "C:\\Windows\\Microsoft.NET\\Framework64\\v4.0.30319\\aspnet_regiis -pi WebTrends.ExternalData.Plugins.AndroidConnector #{install_dir}\\bin\\PublicPrivateKeys.rsa"
  end

  execute "asp_regiis_pa" do
    command  "C:\\Windows\\Microsoft.NET\\Framework64\\v4.0.30319\\aspnet_regiis -pa WebTrends.ExternalData.Plugins.AndroidConnector #{rsa_user}"
  end

  # delete the .rsa file
  file "#{install_dir}\\bin\\PublicPrivateKeys.rsa" do
    action :delete
  end

  wt_base_icacls "C:\\ProgramData\\Microsoft\\Crypto\\RSA\\MachineKeys" do
  user node['current_user']
  perm :modify
  action :remove
  end

  share_wrs
end
