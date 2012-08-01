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
