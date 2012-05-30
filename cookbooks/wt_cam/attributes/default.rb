#
# Author:: Kendrick Martin(<kendrick.martin@webtrends.com>)
# Cookbook Name:: wt_cam
# Attribute:: default
#
# Copyright 2012, Webtrends Inc.
#


default['wt_cam']['app_pool'] = "CAMService"
default['wt_cam']['download_url'] = "http://pdxteamcitys01.webtrends.corp/guestAuth/repository/download/bt122/.lastSuccessful/"
default['wt_cam']['zip_file'] = "CAM.zip"
default['wt_cam']['db_server'] = "(local)"