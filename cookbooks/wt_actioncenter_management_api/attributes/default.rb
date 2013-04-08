#
# Cookbook Name:: wt_actioncenter_management_api
# Attributes:: default
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
#

default['wt_actioncenter_management_api']['user']           = "webtrends"
default['wt_actioncenter_management_api']['group']          = "webtrends"
default['wt_actioncenter_management_api']['download_url']   =
"http://teamcity.webtrends.corp/guestAuth/repository/download/bt372/.lastSuccessful/action-center-management-service-bin.tar.gz"
default['wt_actioncenter_management_api']['message_port']   = 2552
default['wt_actioncenter_management_api']['ads_port'] = 8080
default['wt_actioncenter_management_api']['ads_host'] = "hutil01.staging.dmz"
default['wt_actioncenter_management_api']['cam_host'] = "hcam.staging.dmz"
default['wt_actioncenter_management_api']['cam_port'] = 80
default['wt_actioncenter_management_api']['ds_host'] = "hacds01.staging.dmz"
default['wt_actioncenter_management_api']['ds_port'] = 8080
