#
# Author: Jeff Berger (<jeff.berger@webtrends.com>)
# Cookbook Name:: wt_kafka_mm
# Recipe:: default
#
# Copyright 2012, Webtrends
#

default['wt_kafka_mm']['user'] = "webtrends"
default['wt_kafka_mm']['group'] = "webtrends"
default['wt_kafka_mm']['java_opts'] = "-Xms1024m -Djava.net.preferIPv4Stack=true"
default['wt_kafka_mm']['jmx_port'] = "10000"
default['wt_kafka_mm']['topic_white_list'] = ".*RawHits"
default['wt_kafka_mm']['log_level'] = "INFO"

default['wt_kafka_mm']['sources'] = {}
default['wt_kafka_mm']['target'] = {}

default["wt_kafka_mm"]["averagecount"] = "100"
default["wt_kafka_mm"]["ratethreshold"] = "8000"
default["wt_kafka_mm"]["avgthreshold"] = "8000"
default["wt_kafka_mm"]["producerate"] = "5000"
default["wt_kafka_mm"]["monitor_jmx_port"] = "10005"

default["wt_kafka_mm"]["download_url"] = nil
default["wt_kafka_mm"]["checksum"] = "ee845b947b00d6d83f51a93e6ff748bb03e5945e4f3f12a77534f55ab90cb2a8"