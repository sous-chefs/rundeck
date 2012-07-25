#
# Cookbook Name:: wt_analytics_ui
# Recipe:: iis
#
# Copyright 2012, Webtrends Inc.
#
# All rights reserved - Do Not Redistribute
#

include_recipe "webpi"

webpi_product "StaticContent,DefaultDocument,HTTPErrors,HTTPLogging,RequestFiltering,StaticContentCompression,DynamicContentCompression,IISManagementConsole,ASPNET" do
	accept_eula true
	action :install
end
