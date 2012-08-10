#
# Author:: Sean McNamara (<sean.mcnamara@webtrends.com>)
# Cookbook Name:: storm
# Attribute:: default
#
# Copyright 2012, Webtrends Inc.
#

default['wt_storm']['cluster_role'] = ""

# general storm attributes
default['wt_storm']['java_lib_path'] = "/usr/local/lib:/opt/local/lib:/usr/lib"
default['wt_storm']['local_dir'] = "/mnt/storm"
default['wt_storm']['local_mode_zmq'] = "false"
default['wt_storm']['cluster_mode'] = "distributed"


# zookeeper attributes
default['wt_storm']['zookeeper']['port'] = 2181
default['wt_storm']['zookeeper']['root'] = "/storm"
default['wt_storm']['zookeeper']['session_timeout'] = 20000
default['wt_storm']['zookeeper']['retry_times'] = 5
default['wt_storm']['zookeeper']['retry_interval'] = 1000


# supervisor attributes
default['wt_storm']['supervisor']['workers'] = 4
default['wt_storm']['supervisor']['childopts'] = "-Xmx1024m"
default['wt_storm']['supervisor']['worker_start_timeout'] = 120
default['wt_storm']['supervisor']['worker_timeout_secs'] = 30
default['wt_storm']['supervisor']['monitor_frequecy_secs'] = 3
default['wt_storm']['supervisor']['heartbeat_frequency_secs'] = 5
default['wt_storm']['supervisor']['enable'] = true


# worker attributes
default['wt_storm']['worker']['childopts'] = "-Xmx768m -XX:+UseConcMarkSweepGC -Dcom.sun.management.jmxremote"
default['wt_storm']['worker']['heartbeat_frequency_secs'] = 1
default['wt_storm']['task']['heartbeat_frequency_secs'] = 3
default['wt_storm']['task']['refresh_poll_secs'] = 10
default['wt_storm']['zmq']['threads'] = 1
default['wt_storm']['zmq']['longer_millis'] = 5000


# nimbus attributes
default['wt_storm']['nimbus']['host'] = ""
default['wt_storm']['nimbus']['thrift_port'] = 6627
default['wt_storm']['nimbus']['childopts'] = "-Xmx1024m"
default['wt_storm']['nimbus']['task_timeout_secs'] = 30
default['wt_storm']['nimbus']['supervisor_timeout_secs'] = 60
default['wt_storm']['nimbus']['monitor_freq_secs'] = 10
default['wt_storm']['nimbus']['cleanup_inbox_freq_secs'] = 600
default['wt_storm']['nimbus']['inbox_jar_expiration_secs'] = 3600
default['wt_storm']['nimbus']['task_launch_secs'] = 120
default['wt_storm']['nimbus']['reassign'] = true
default['wt_storm']['nimbus']['file_copy_expiration_secs'] = 600


# ui attributes
default['wt_storm']['ui']['port'] = 8080
default['wt_storm']['ui']['childopts'] = "-Xmx768m"


# drpc attributes
default['wt_storm']['drpc']['port'] = 3772
default['wt_storm']['drpc']['invocations_port'] = 3773
default['wt_storm']['drpc']['request_timeout_secs'] = 600


# transactional attributes
default['wt_storm']['transactional']['zookeeper']['root'] = "/storm-transactional"
default['wt_storm']['transactional']['zookeeper']['port'] = 2181


# topology attributes
default['wt_storm']['topology']['debug'] = false
default['wt_storm']['topology']['optimize'] = true
default['wt_storm']['topology']['workers'] = 1
default['wt_storm']['topology']['acker_executors'] = 1
default['wt_storm']['topology']['acker_tasks'] = "null"
default['wt_storm']['topology']['tasks'] = "null"
default['wt_storm']['topology']['message_timeout_secs'] = 30
default['wt_storm']['topology']['skip_missing_kryo_registrations'] = false
default['wt_storm']['topology']['max_task_parallelism'] = "null"
default['wt_storm']['topology']['max_spout_pending'] = "null"
default['wt_storm']['topology']['state_synchronization_timeout_secs'] = 60
default['wt_storm']['topology']['stats_sample_rate'] = 0.05
default['wt_storm']['topology']['fall_back_on_java_serialization'] = true
default['wt_storm']['topology']['worker_childopts'] = "null"

