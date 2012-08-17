#
# Author:: Sean McNamara (<sean.mcnamara@webtrends.com>)
# Cookbook Name:: wt_storm_realtime
# Attribute:: default
#
# Copyright 2012, Webtrends Inc.
#

default['wt_storm_realtime']['cluster_role'] = "wt_storm_realtime_realtime"

# general storm attributes
default['wt_storm_realtime']['java_lib_path'] = "/usr/local/lib:/opt/local/lib:/usr/lib"
default['wt_storm_realtime']['local_dir'] = "/mnt/storm"
default['wt_storm_realtime']['local_mode_zmq'] = "false"
default['wt_storm_realtime']['cluster_mode'] = "distributed"


# zookeeper attributes
default['wt_storm_realtime']['zookeeper']['root'] = "/v2-storm-realtime"
default['wt_storm_realtime']['zookeeper']['session_timeout'] = 20000
default['wt_storm_realtime']['zookeeper']['retry_times'] = 5
default['wt_storm_realtime']['zookeeper']['retry_interval'] = 1000


# supervisor attributes
default['wt_storm_realtime']['supervisor']['workers'] = 4
default['wt_storm_realtime']['supervisor']['childopts'] = "-Xmx1024m"
default['wt_storm_realtime']['supervisor']['worker_start_timeout'] = 120
default['wt_storm_realtime']['supervisor']['worker_timeout_secs'] = 30
default['wt_storm_realtime']['supervisor']['monitor_frequecy_secs'] = 3
default['wt_storm_realtime']['supervisor']['heartbeat_frequency_secs'] = 5
default['wt_storm_realtime']['supervisor']['enable'] = true


# worker attributes
default['wt_storm_realtime']['worker']['childopts'] = "-Xmx768m -XX:+UseConcMarkSweepGC -Dcom.sun.management.jmxremote"
default['wt_storm_realtime']['worker']['heartbeat_frequency_secs'] = 1
default['wt_storm_realtime']['task']['heartbeat_frequency_secs'] = 3
default['wt_storm_realtime']['task']['refresh_poll_secs'] = 10
default['wt_storm_realtime']['zmq']['threads'] = 1
default['wt_storm_realtime']['zmq']['longer_millis'] = 5000


# nimbus attributes
default['wt_storm_realtime']['nimbus']['host'] = ""
default['wt_storm_realtime']['nimbus']['thrift_port'] = 6627
default['wt_storm_realtime']['nimbus']['childopts'] = "-Xmx1024m"
default['wt_storm_realtime']['nimbus']['task_timeout_secs'] = 30
default['wt_storm_realtime']['nimbus']['supervisor_timeout_secs'] = 60
default['wt_storm_realtime']['nimbus']['monitor_freq_secs'] = 10
default['wt_storm_realtime']['nimbus']['cleanup_inbox_freq_secs'] = 600
default['wt_storm_realtime']['nimbus']['inbox_jar_expiration_secs'] = 3600
default['wt_storm_realtime']['nimbus']['task_launch_secs'] = 120
default['wt_storm_realtime']['nimbus']['reassign'] = true
default['wt_storm_realtime']['nimbus']['file_copy_expiration_secs'] = 600


# ui attributes
default['wt_storm_realtime']['ui']['port'] = 8080
default['wt_storm_realtime']['ui']['childopts'] = "-Xmx768m"


# drpc attributes
default['wt_storm_realtime']['drpc']['port'] = 3772
default['wt_storm_realtime']['drpc']['invocations_port'] = 3773
default['wt_storm_realtime']['drpc']['request_timeout_secs'] = 600


# transactional attributes
default['wt_storm_realtime']['transactional']['zookeeper']['root'] = "/v2-storm-realtime-transactional"


# topology attributes
default['wt_storm_realtime']['topology']['debug'] = false
default['wt_storm_realtime']['topology']['optimize'] = true
default['wt_storm_realtime']['topology']['workers'] = 1
default['wt_storm_realtime']['topology']['acker_executors'] = 1
default['wt_storm_realtime']['topology']['acker_tasks'] = "null"
default['wt_storm_realtime']['topology']['tasks'] = "null"
default['wt_storm_realtime']['topology']['message_timeout_secs'] = 30
default['wt_storm_realtime']['topology']['skip_missing_kryo_registrations'] = false
default['wt_storm_realtime']['topology']['max_task_parallelism'] = "null"
default['wt_storm_realtime']['topology']['max_spout_pending'] = "null"
default['wt_storm_realtime']['topology']['state_synchronization_timeout_secs'] = 60
default['wt_storm_realtime']['topology']['stats_sample_rate'] = 0.05
default['wt_storm_realtime']['topology']['fall_back_on_java_serialization'] = true
default['wt_storm_realtime']['topology']['worker_childopts'] = "null"

