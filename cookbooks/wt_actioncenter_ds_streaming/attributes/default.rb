#
# Cookbook Name:: wt_actioncenter_ds_streaming
# Attributes:: default
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
#

default['wt_actioncenter_ds_streaming']['user']           = "webtrends"
default['wt_actioncenter_ds_streaming']['group']          = "webtrends"
default['wt_actioncenter_ds_streaming']['download_url']   =
"http://teamcity.webtrends.corp/guestAuth/repository/download/bt370/.lastSuccessful/action-center-datasource-processor-develop-SNAPSHOT-bin.tar.gz"
default['wt_actioncenter_ds_streaming']['message_port']   = 2552
default['wt_actioncenter_ds_streaming']['sapi_host'] = "hsapi.webtrends.com"
default['wt_actioncenter_ds_streaming']['client_id'] =
"5dc19a573395451cb90330f128807cee.app.webtrends.com"

default['wt_actioncenter_ds_streaming']['client_secret'] =
"6f6525b6cc1a4ab285023be1a5c2b5ad"

default['wt_actioncenter_ds_streaming']['auth_url'] =
"https://hsauth.webtrends.com/v1/token"

default['wt_actioncenter_ds_streaming']['auth_user_id'] = "143"
default['wt_actioncenter_ds_streaming']['config_host'] = "hutil01.staging.dmz"
default['wt_actioncenter_ds_streaming']['config_port'] = "8080"
