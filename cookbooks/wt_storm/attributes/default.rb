#
# Author:: Sean McNamara (<sean.mcnamara@webtrends.com>)
# Cookbook Name:: storm
# Attribute:: default
#
# Copyright 2012, Webtrends Inc.
#

# jar download path
default['wt_storm']['download_url'] = ""

default['wt_storm']['dcsid_whitelist'] = ""
default['wt_storm']['debug'] = "false"




default['wt_storm']['streaming_topology']['streaming_topology_parsing_bolt_count'] = 1
default['wt_storm']['streaming_topology']['streaming_topology_in_session_bolt_count'] = 1
default['wt_storm']['streaming_topology']['streaming_topology_zmq_emitter_bolt_count'] = 1
default['wt_storm']['streaming_topology']['streaming_topology_validation_bolt_count'] = 1
default['wt_storm']['streaming_topology']['streaming_topology_augmentation_bolt_count'] = 1
