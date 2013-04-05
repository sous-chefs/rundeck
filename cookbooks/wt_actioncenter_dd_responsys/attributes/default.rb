#
# Cookbook Name:: wt_actioncenter_dd_responsys
# Attributes:: default
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
#

default['wt_actioncenter_dd_responsys']['user']           = "webtrends"
default['wt_actioncenter_dd_responsys']['group']          = "webtrends"
default['wt_actioncenter_dd_responsys']['download_url']   =
"http://teamcity.webtrends.corp/guestAuth/repository/download/bt376/.lastSuccessful/action-center-integrations-responsys-bin.tar.gz"
default['wt_actioncenter_dd_responsys']['message_port']   = 2552

default['wt_actioncenter_dd_responsys']['config_host'] = "hutil01.staging.dmz"

default['wt_actioncenter_dd_responsys']['config_port'] = "8080"
