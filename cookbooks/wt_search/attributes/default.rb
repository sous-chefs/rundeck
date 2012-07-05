#
# Author:: Kendrick Martin(<kendrick.martin@webtrends.com>)
# Cookbook Name:: wt_search
# Attribute:: default
#
# Copyright 2012, Webtrends Inc.
#

default['wt_search']['artifact'] = "Search.zip"
default['wt_search']['tc_proj'] = "Search"
default['wt_search']['service_name'] = "Webtrends Search Service"
default['wt_search']['service_binary'] = "Webtrends.Search.Service.exe"
default['wt_search']['install_dir'] = "\\Search\\bin"
default['wt_search']['log_dir'] = "\\Search\\logs"
default['wt_search']['download_url'] = "http://teamcity.webtrends.corp/guestAuth/repository/download/bt20/.lastSuccessful/Search.zip"