#
# Author:: Kendrick Martin(<kendrick.martin@webtrends.com>)
# Cookbook Name:: wt_cam
# Attribute:: default
#
# Copyright 2012, Webtrends Inc.
#

default['wt_streaming_viz']['app_pool'] = "StreamingViz"
default['wt_streaming_viz']['download_url'] = ""
#default['wt_streaming_viz']['db_server'] = "(local)"
#default['wt_streaming_viz']['db_name'] = "Cam"
#default['wt_streaming_viz']['tokenExpirationMinutes'] = 60
default['wt_streaming_viz']['port'] = 85
default['wt_streaming_viz']['log_level'] = "INFO"
default['wt_streaming_viz']['cam_auth_uri'] = ""
default['wt_streaming_viz']['sapi_uri'] = ""
default['wt_streaming_viz']['elmah_remote_access'] = "no"
default['wt_streaming_viz']['custom_errors'] = "On"
default['wt_streaming_viz']['proxy_enabled'] = "false"
default['wt_streaming_viz']['proxy_address'] = ""
