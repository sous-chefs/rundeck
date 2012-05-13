#
# Author:: Sean McNamara (<sean.mcnamara@webtrends.com>)
# Cookbook Name:: storm
# Attribute:: default
#
# Copyright 2012, Webtrends Inc.
#

# installation attributes
default['storm']['version'] = "0.7.1"
default['storm']['install_dir'] = "/opt/storm"

# general storm attributes
default['storm']['localdir'] = "/mnt/storm"
default['storm']['zk_port'] = 2181
default['storm']['zk_session_timeout'] = 20000
default['storm']['sk_retry_attempts'] = 5
default['storm']['sk_retry_interval'] = 1000
default['storm']['cluster_mode'] = "distributed"
default['storm']['local_mode_zmq'] = "false"

# nimbus attributes
default['storm']['nimbus_thrift_port'] = 6627
default['storm']['nimbus_childopts'] = "-Xmx1024m"
default['storm']['nimbus_task_timeout'] = 30
default['storm']['nimbus_supervisor_timeout_secs'] = 60
default['storm']['nimbus_monitor_freq_secs'] = 10
default['storm']['nimbus_cleanup_inbox_freq_secs'] = 600
default['storm']['nimbus_inbox_jar_expiration_secs'] = 3600
default['storm']['nimbus_task_launch_secs'] = 120
default['storm']['nimbus_reassign'] = "true"
default['storm']['nimbus_file_copy_expiration_secs'] = 600

# ui attributes
default['storm']['ui_port'] = 8080
default['storm']['ui_childopts'] = "-Xmx768m"

# drpc attributes
default['storm']['drpc_port'] = drpc.port: 3772
default['storm']['drpc_ivocations_port'] = drpc.invocations.port: 3773
default['storm']['drpc_request_timeout_secs'] = drpc.request.timeout.secs: 600

# transactional options
default['storm']['transactional_zookeeper_root'] = "/transactional"
default['storm']['transactional_zookeeper_servers'] = "null"
default['storm']['transactional_zookeeper_port'] = "null"

# supervisor options
default['storm']['supervisor_childopts'] = supervisor.childopts: "-Xmx1024m"
default['storm']['supervisor_worker_start_timeout_secs'] = 120
default['storm']['supervisor_worker_timeout_secs'] = 30
default['storm']['supervisor_monitor_frequency_secs'] = 3
default['storm']['supervisor_heartbeat_frequency_secs'] = 5
default['storm']['supervisor_enable'] = "true"

# worker options
default['storm']['woker_childopts'] = "-Xmx768m"
default['storm']['heartbeat_frequency_secs'] = 1

# task attributes
default['storm']['task_heartbeat_frequency_secs'] = 3
default['storm']['task_refresh_poll_secs'] = 10

# zeromq attributes
default['storm']['zmq_threads'] = 1
default['storm']['zmq_linger_millis'] = 5000

# topology options
default['storm']['topology_debug'] = "false"
default['storm']['topology_optimize'] = "true"
default['storm']['topology_workers'] = 1
default['storm']['topology_acker_executers'] = 1
default['storm']['topology_acker_tasks'] = "null"
default['storm']['topology_tasks'] = "null"
default['storm']['topology_message_timeout_secs'] = 30
default['storm']['topology_skip_missing_kryo_registrations'] = "false"
default['storm']['topology_max_task_parallelism'] = "null"
default['storm']['topology_max_spout_pending'] = "null"
default['storm']['topology_state_synchronization_timeout_secs'] = 60
default['storm']['topology_stats_sample_rate'] = 0.05
default['storm']['topology_fall_back_on_java_serialization'] = "true"
default['storm']['topology_worker_childopts'] = "null"