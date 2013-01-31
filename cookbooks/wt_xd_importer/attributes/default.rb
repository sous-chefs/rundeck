#
# Cookbook Name:: wt_xd_importer
# Attributes:: default
#
# Copyright 2012, Webtrends Inc.
#
# All rights reserved - Do Not Redistribute
#

##These attributes are for the windows services
default['wt_xd_importer']['download_url'] = ''
default['wt_xd_importer']['install_dir'] = "xd\\bin"
default['wt_xd_importer']['plugins'] = ["Webtrends.ExternalData.Plugins.AndroidConnector", "Webtrends.ExternalData.Plugins.BitlyConnector", 
	"Webtrends.ExternalData.Plugins.FacebookConnector", "Webtrends.ExternalData.Plugins.iTunesConnector", "Webtrends.ExternalData.Plugins.ThumbnailConnector", 
	"Webtrends.ExternalData.Plugins.YouTubeConnector", "Webtrends.ExternalData.Plugins.TwitterConnector", "Webtrends.ExternalData.Plugins.UrlInfoConnector", "Webtrends.ExternalData.Plugins.SftpPush"]
default['wt_xd_importer']['retrieval']['service_name'] = "Webtrends External Data Retrieval Service"
default['wt_xd_importer']['storage']['service_name'] = "Webtrends External Data Storage Service"
default['wt_xd_importer']['retrieval']['service_binary'] = "Webtrends.ExternalData.RetrievalService.exe"
default['wt_xd_importer']['storage']['service_binary'] = "Webtrends.ExternalData.StorageService.exe"
default['wt_xd_importer']['refresh']['binary'] = "Webtrends.ExternalData.Refresh.exe"

