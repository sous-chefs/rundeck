#
# Cookbook Name:: wt_streamingapi
# Attributes:: default
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
#

default['wt_streamingapi']['user']                     = "webtrends"
default['wt_streamingapi']['group']                    = "webtrends"
default['wt_streamingapi']['download_url']             = "http://teamcity.webtrends.corp/guestAuth/repository/download/bt76/.lastSuccessful/webtrends-streamingapi-bin.tar.gz"
default['wt_streamingapi']['port']                     = "8080"
default['wt_streamingapi']['java_opts']                = "-Xms2048m -Djava.net.preferIPv4Stack=true"
default['wt_streamingapi']['writeBufferHighWaterMark'] = 33554432


