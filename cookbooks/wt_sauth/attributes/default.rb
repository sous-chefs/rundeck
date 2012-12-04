#
# Author:: Kendrick Martin(<kendrick.martin@webtrends.com>)
# Cookbook Name:: wt_sauth
# Attribute:: default
#
# Copyright 2012, Webtrends Inc.
#

default['wt_sauth']['app_pool'] = "SAUTH"
default['wt_sauth']['download_url'] = ""
default['wt_sauth']['tokenExpirationMinutes'] = 60
default['wt_sauth']['authCodeExpirationMinutes'] = 10
default['wt_sauth']['login_domains'] = "webtrends.com"
default['wt_sauth']['port'] = 80
default['wt_sauth']['log_level'] = "INFO"
