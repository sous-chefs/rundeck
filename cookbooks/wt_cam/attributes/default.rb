#
# Author:: Kendrick Martin(<kendrick.martin@webtrends.com>)
# Cookbook Name:: wt_cam
# Attribute:: default
#
# Copyright 2012, Webtrends Inc.
#


default['wt_cam']['app_pool'] = "CAM"
default['wt_cam']['camlite_app_pool'] = "CAMService"
default['wt_cam']['download_url'] = "http://pdxteamcitys01.webtrends.corp/guestAuth/repository/download/bt137/.lastSuccessful/CAM.zip"
default['wt_cam']['camlite_download_url'] = "http://pdxteamcitys01.webtrends.corp/guestAuth/repository/download/bt122/.lastSuccessful/CAM.zip"
default['wt_cam']['auth_download_url'] = "http://pdxteamcitys01.webtrends.corp/guestAuth/repository/download/bt137/.lastSuccessful/Auth.zip"
default['wt_cam']['db_server'] = "(local)"
default['wt_cam']['db_name'] = "Cam"
default['wt_cam']['camlite_db_name'] = "wtCamLite"
default['wt_cam']['tokenExpirationMinutes'] = 60
