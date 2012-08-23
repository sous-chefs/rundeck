#
# Author:: Kendrick Martin(<kendrick.martin@webtrends.com>)
# Cookbook Name:: wt_cam
# Attribute:: default
#
# Copyright 2012, Webtrends Inc.
#

default['wt_cam']['app_pool'] = "CAM"
default['wt_cam']['camlite_app_pool'] = "CAMService"
default['wt_cam']['cam'] ['download_url'] = "http://pdxteamcitys01.webtrends.corp/guestAuth/repository/download/bt137/.lastSuccessful/CAM.zip"
default['wt_cam']['camlite']['download_url'] = "http://pdxteamcitys01.webtrends.corp/guestAuth/repository/download/bt122/.lastSuccessful/CAM.zip"
default['wt_cam']['auth']['download_url'] = "http://pdxteamcitys01.webtrends.corp/guestAuth/repository/download/bt137/.lastSuccessful/Auth.zip"
default['wt_cam']['db_server'] = "(local)"
default['wt_cam']['db_name'] = "Cam"
default['wt_cam']['camlite_db_name'] = "wtCamLite"
default['wt_cam']['tokenExpirationMinutes'] = 60
default['wt_cam']['cam']['port'] = 80
default['wt_cam']['auth']['port'] = 81
default['wt_cam']['camlite']['port'] = 82
default['wt_cam']['cam']['log_level'] = "INFO"
default['wt_cam']['auth']['log_level'] = "INFO"
