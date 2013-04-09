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
default['wt_actioncenter_ds_streaming']['sapi_port'] = 8080

default['wt_actioncenter_ds_streaming']['client_id'] =
"e8ae471a23ef486986db824d41e3a4d7.app.webtrends.com"

default['wt_actioncenter_ds_streaming']['client_secret'] =
"94ac26f39c4045299e6c300198cd7f54"

default['wt_actioncenter_ds_streaming']['auth_url'] =
"https://hsauth.webtrends.com/v1/token"

default['wt_actioncenter_ds_streaming']['auth_user_id'] = "143"
default['wt_actioncenter_ds_streaming']['config_host'] = "hutil01.staging.dmz"
default['wt_actioncenter_ds_streaming']['config_port'] = "8080"
default['wt_actioncenter_ds_streaming']['zk_connect'] =
"hzoo02.staging.dmz:2181,hzoo03.staging.dmz:2181,hzoo01.staging.dmz:2181"
default['wt_actioncenter_ds_streaming']['kafka_topic'] = "Lab_H_ActionRoutes"
