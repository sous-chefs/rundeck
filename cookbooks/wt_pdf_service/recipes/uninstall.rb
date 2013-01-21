#
# Cookbook Name:: wt_pdf_service
# Recipe:: uninstall
# Author:: Michael Parsons(<michael.parsons@webtrends.com>)
#
# Copyright 2012, Webtrends Inc.
#
# All rights reserved - Do Not Redistribute
#

app_pool = node['wt_pdf_service']['app_pool_name']
install_dir = File.join(node['wt_common']['install_dir_windows'],
node['wt_pdf_service']['install_dir']).gsub(/[\\\/]+/,"\\")

iis_pool app_pool do
  	action [:stop, :delete]
  	ignore_failure true
end

iis_site 'PDFService' do
	action [:stop, :delete]
  	ignore_failure true
end

directory install_dir do
	recursive true
	action :delete
end

directory "d:\\wrs\\PDFService" do
	recursive true
	action :delete
end
