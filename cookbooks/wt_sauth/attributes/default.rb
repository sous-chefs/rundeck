#
# Author:: Kendrick Martin(<kendrick.martin@webtrends.com>)
# Cookbook Name:: wt_sauth
# Attribute:: default
#
# Copyright 2012, Webtrends Inc.
#

default['wt_sauth']['app_pool'] = "SAUTH"
default['wt_sauth']['auth']['download_url'] = ""
default['wt_sauth']['db_server'] = "(local)"
default['wt_sauth']['db_name'] = "Cam"
default['wt_sauth']['tokenExpirationMinutes'] = 60
default['wt_sauth']['port'] = 81
default['wt_sauth']['log_level'] = "INFO"
