#
# Author:: Kendrick Martin(<kendrick.martin@webtrends.com>)
# Cookbook Name:: wt_streaming_viz
# Attribute:: default
#
# Copyright 2012, Webtrends Inc.
#

default['wt_streaming_viz']['app_pool'] = "StreamingViz"
default['wt_streaming_viz']['download_url'] = ""
#default['wt_streaming_viz']['db_server'] = "(local)"
#default['wt_streaming_viz']['db_name'] = "Cam"
#default['wt_streaming_viz']['tokenExpirationMinutes'] = 60
default['wt_streaming_viz']['port'] = 80
default['wt_streaming_viz']['log_level'] = "INFO"
default['wt_streaming_viz']['elmah_remote_access'] = "no"
default['wt_streaming_viz']['custom_errors'] = "On"
default['wt_streaming_viz']['proxy_enabled'] = "true"
default['wt_streaming_viz']['auth_service_url_base'] = "/token"
default['wt_streaming_viz']['auth_service_version'] = "v1"
default['wt_streaming_viz']['cam_service_url_base'] = ""
default['wt_streaming_viz']['streams_ui_url'] = ""
default['wt_streaming_viz']['sms_url'] = ""

