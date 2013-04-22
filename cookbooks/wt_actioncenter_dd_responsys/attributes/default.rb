#
# Cookbook Name:: wt_actioncenter_dd_responsys
# Attributes:: default
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
#

default['wt_actioncenter_dd_responsys']['user']           														= "webtrends"
default['wt_actioncenter_dd_responsys']['group']          														= "webtrends"
default['wt_actioncenter_dd_responsys']['download_url']   														= ""
default['wt_actioncenter_dd_responsys']['message_port']   														= 2552
default['wt_actioncenter_dd_responsys']['datarequest_max_events_in_batch'] 						=	"200"
default['wt_actioncenter_dd_responsys']['datarequest_failure_delay_before_retry_ms']  = "60000"
default['wt_actioncenter_dd_responsys']['datarequest_nodata_delay_before_retry_ms']   =	"5000"
default['wt_actioncenter_dd_responsys']['sender_max_send_retries']   									=	"5"
default['wt_actioncenter_dd_responsys']['sender_min_exponential_backoff_delay_ms']    =	"5000"
default['wt_actioncenter_dd_responsys']['sender_max_delay_before_dropping_data_ms']   =	"3600000"
default['wt_actioncenter_dd_responsys']['testing_enabled']                            =	"false"
default['wt_actioncenter_dd_responsys']['testing_key_column_override']                =	"173453478"
