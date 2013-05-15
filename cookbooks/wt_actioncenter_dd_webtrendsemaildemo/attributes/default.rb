#
# Cookbook Name:: wt_actioncenter_dd_webtrendsemaildemo
# Attributes:: default
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
#

default['wt_actioncenter_dd_webtrendsemaildemo']['user'] = "webtrends"
default['wt_actioncenter_dd_webtrendsemaildemo']['group']= "webtrends"
default['wt_actioncenter_dd_webtrendsemaildemo']['download_url']= ""
default['wt_actioncenter_dd_webtrendsemaildemo']['datarequest_max_event_batch_time_ms']			  = "2000"
default['wt_actioncenter_dd_webtrendsemaildemo']['datarequest_max_events_in_batch'] 					=	"200"
default['wt_actioncenter_dd_webtrendsemaildemo']['datarequest_failure_delay_before_retry_ms'] = "60000"
default['wt_actioncenter_dd_webtrendsemaildemo']['datarequest_nodata_delay_before_retry_ms']  =	"5000"
default['wt_actioncenter_dd_webtrendsemaildemo']['sender_max_send_retries']   								=	"5"
default['wt_actioncenter_dd_webtrendsemaildemo']['sender_min_exponential_backoff_delay_ms']   =	"5000"
default['wt_actioncenter_dd_webtrendsemaildemo']['sender_max_delay_before_dropping_data_ms']  =	"3600000"
