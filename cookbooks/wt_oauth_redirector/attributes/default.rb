#
# Cookbook Name:: wt_oauth_redirector
# Recipe:: default
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
#

default['wt_oauth_redirector']['download_url'] = "http://teamcity.webtrends.corp/guestAuth/repository/download/bt173/.lastSuccessful/oauth-redirector.tar.gz"
default['wt_oauth_redirector']['logname'] = "oauth.log"
default['wt_oauth_redirector']['port'] = 3000