#
# Cookbook Name:: wt_analytics_ui
# Recipe:: iis
#
# Copyright 2012, Webtrends Inc.
#
# All rights reserved - Do Not Redistribute
#

include_recipe "webpi"

iis_components = "StaticContent,DefaultDocument,HTTPErrors,HTTPLogging,RequestMonitor,RequestFiltering,StaticContentCompression,IISManagementConsole,DynamicContentCompression,ASPNET"

webpi_product iis_components do
	accept_eula true
	action :install
end

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

