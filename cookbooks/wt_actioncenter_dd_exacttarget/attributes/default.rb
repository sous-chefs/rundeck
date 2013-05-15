#
# Cookbook Name:: wt_actioncenter_dd_exacttarget
# Attributes:: default
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
#

default['wt_actioncenter_dd_exacttarget']['user']           														= "webtrends"
default['wt_actioncenter_dd_exacttarget']['group']          														= "webtrends"
default['wt_actioncenter_dd_exacttarget']['download_url']   														= ""
default['wt_actioncenter_dd_exacttarget']['datarequest_max_event_batch_time_ms']			  = "2000"
default['wt_actioncenter_dd_exacttarget']['datarequest_max_events_in_batch'] 						=	"200"
default['wt_actioncenter_dd_exacttarget']['datarequest_failure_delay_before_retry_ms'] 	= "60000"
default['wt_actioncenter_dd_exacttarget']['datarequest_nodata_delay_before_retry_ms']  	=	"5000"
default['wt_actioncenter_dd_exacttarget']['sender_max_send_retries']   									=	"5"
default['wt_actioncenter_dd_exacttarget']['sender_min_exponential_backoff_delay_ms']   	=	"5000"
default['wt_actioncenter_dd_exacttarget']['sender_max_delay_before_dropping_data_ms']  	=	"3600000"
default['wt_actioncenter_dd_exacttarget']['testing_enabled']                            =	"false"
default['wt_actioncenter_dd_exacttarget']['testing_key_column_override']                =	"173453478"
