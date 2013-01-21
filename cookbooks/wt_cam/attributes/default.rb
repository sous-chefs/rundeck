#
# Author:: Kendrick Martin(<kendrick.martin@webtrends.com>)
# Cookbook Name:: wt_cam
# Attribute:: default
#
# Copyright 2012, Webtrends Inc.
#

default['wt_cam']['app_pool'] = "CAM"
default['wt_cam']['download_url'] = ""
default['wt_cam']['cam_plugins']['download_url'] = ""
default['wt_cam']['db_server'] = "(local)"
default['wt_cam']['db_name'] = "Cam"
default['wt_cam']['tokenExpirationMinutes'] = 60
default['wt_cam']['port'] = 80
default['wt_cam']['log_level'] = "INFO"
default['wt_cam']['optimize_plugin']['guest_user'] = "internalGuestUser"
default['wt_cam']['optimize_plugin']['optimize_server_url'] = ""
