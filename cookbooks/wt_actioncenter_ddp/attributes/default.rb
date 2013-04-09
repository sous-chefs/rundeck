#
# Cookbook Name:: wt_actioncenter_ddp
# Attributes:: default
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
#

default['wt_actioncenter_ddp']['user']           = "webtrends"
default['wt_actioncenter_ddp']['group']          = "webtrends"
default['wt_actioncenter_ddp']['download_url']   =
"http://teamcity.webtrends.corp/guestAuth/repository/download/bt371/.lastSuccessful/action-center-datadestination-processor-develop-SNAPSHOT-bin.tar.gz"
default['wt_actioncenter_ddp']['message_port']   = 2552
default['wt_actioncenter_ddp']['kafka_topic'] = "Lab_H_ActionRoutes"
