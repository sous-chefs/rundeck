#
# Cookbook Name:: wt_xd
# Attributes:: default
#
# Copyright 2012, Webtrends Inc.
#
# All rights reserved - Do Not Redistribute
#

default['wt_xd']['download_url'] = ''
default['wt_xd']['log_level']    = 'INFO'
default['wt_xd']['mapred_child_java_opts'] = '-server -Xmx2048m -Djava.net.preferIPv4Stack=true'

##These attributes are for the windows services
default['wt_xd']['importer']['download_url'] = ''
default['wt_xd']['importer']['install_dir'] = "xd\\bin"
default['wt_xd']['importer']['plugins'] = ["Webtrends.ExternalData.Plugins.AndroidConnector", "Webtrends.ExternalData.Plugins.BitlyConnector", 
	"Webtrends.ExternalData.Plugins.FacebookConnector", "Webtrends.ExternalData.Plugins.iTunesConnector", "Webtrends.ExternalData.Plugins.ThumbnailConnector", 
	"Webtrends.ExternalData.Plugins.YouTubeConnector", "Webtrends.ExternalData.Plugins.TwitterConnector", "Webtrends.ExternalData.Plugins.UrlInfoConnector", "Webtrends.ExternalData.Plugins.SftpPush"]
default['wt_xd']['retrieval']['service_name'] = "Webtrends External Data Retrieval Service"
default['wt_xd']['storage']['service_name'] = "Webtrends External Data Storage Service"
default['wt_xd']['retrieval']['service_binary'] = "Webtrends.ExternalData.RetrievalService.exe"
default['wt_xd']['storage']['service_binary'] = "Webtrends.ExternalData.StorageService.exe"
