#
# Author:: Kendrick Martin(<kendrick.martin@webtrends.com>)
# Cookbook Name:: wt_dx
# Attribute:: default
#
# Copyright 2012, Webtrends Inc.
#

default['wt_dx']['cfg_cmd'] = ["/section:staticContent /clientCache.cacheControlMode:UseMaxAge /clientCache.cacheControlMaxAge:04:00:00","/section:urlCompression /doStaticCompression:True","/section:urlCompression /doDynamicCompression:True","/section:httpCompression -[name='gzip'].dynamicCompressionLevel:4","/section:httpCompression -[name='gzip'].staticCompressionLevel:9","/section:httpCompression -[name='deflate'].dynamicCompressionLevel:4","/section:httpCompression -[name='deflate'].staticCompressionLevel:9","/section:system.webServer/httpErrors /errorMode:Detailed","/section:system.applicationHost/sites /siteDefaults.logfile.directory:\"D:\\wrs\\logs\"","/section:system.applicationHost/sites /siteDefaults.logfile.logExtFileFlags:BytesRecv,BytesSent,ClientIP,ComputerName,Cookie,Date,Host,HttpStatus,HttpSubStatus,Method,ProtocolVersion,Referer,ServerIP,ServerPort,SiteName,Time,TimeTaken,UriQuery,UriStem,UserAgent,UserName,Win32Status","/section:system.webServer/httpErrors /errorMode:DetailedLocalOnly","/section:system.webServer/httpLogging /SelectiveLogging:LogAll"]
default['wt_dx']['website_name'] = "DX"
default['wt_dx']['cacheenabled'] = "True"
default['wt_dx']['website_port'] = 80
default['wt_dx']['download_url'] = ""

default['wt_dx']['v2_1']['app_pool'] = "Webtrends_WebServices_v2_1"
default['wt_dx']['v2_1']['file_name'] = "v2_1.zip"

default['wt_dx']['v3']['file_name'] = "v3.zip"
default['wt_dx']['v3']['streamingservices']['app_pool'] = "Webtrends_StreamingService_v3"
default['wt_dx']['v3']['webservices']['app_pool'] = "Webtrends_WebService_v3"