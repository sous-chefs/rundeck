#
# Cookbook Name:: wt_base
# Recipe:: iis_config
#
# Copyright 2012, Webtrends Inc.
#
# All rights reserved - Do Not Redistribute
#

appcmd = Array.new

# set 4 hour content expiration to allow browser caching
# note: A10 includes this in the web.config so this may not be necessary on an A10 system
appcmd << "/section:staticContent /clientCache.cacheControlMode:UseMaxAge /clientCache.cacheControlMaxAge:04:00:00"

# enable compression of static & dynamic content
# note:  in IIS 7.5 the default value of the doStaticCompression and doDynamicCompression changed from false to true
appcmd << "/section:urlCompression /doStaticCompression:True"
appcmd << "/section:urlCompression /doDynamicCompression:True"

# enable deflate compression format compression
appcmd << "/section:httpCompression /+\"[name='deflate',doStaticCompression='True',doDynamicCompression='True',dll='%windir%\\system32\\inetsrv\\gzip.dll']\" /commit:apphost"

# set reasonable compression levels for deflate and gzip
appcmd << "/section:httpCompression \"-[name='gzip'].dynamicCompressionLevel:4\""
appcmd << "/section:httpCompression \"-[name='gzip'].staticCompressionLevel:9\""
appcmd << "/section:httpCompression \"-[name='deflate'].dynamicCompressionLevel:4\""
appcmd << "/section:httpCompression \"-[name='deflate'].staticCompressionLevel:9\""

# set IIS logging
appcmd << "/section:system.webServer/httpErrors /errorMode:Detailed"
appcmd << "/section:system.applicationHost/sites /siteDefaults.logfile.logExtFileFlags:\"BytesRecv,BytesSent,ClientIP,ComputerName,Cookie,Date,Host,HttpStatus,HttpSubStatus,Method,ProtocolVersion,Referer,ServerIP,ServerPort,SiteName,Time,TimeTaken,UriQuery,UriStem,UserAgent,UserName,Win32Status\""
appcmd << "/section:system.applicationHost/sites /siteDefaults.logfile.directory:\"#{wt_config['install_dir_windows']}\\logs\""

appcmd.each do |thiscmd|
	iis_config "Webtrends IIS Config" do
		cfg_cmd thiscmd
		action :config
	end
end
