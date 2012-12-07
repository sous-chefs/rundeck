#
# Author:: David Dvorak (<david.dvorak@webtrends.com>)
# Cookbook Name:: cassandra
# Attribute:: default
#
# Copyright 2012, Webtrends Inc.
#

# download paths for jna and mx4j
default['cassandra']['mx4j_url'] = "http://sourceforge.net/projects/mx4j/files/MX4J%20Binary/3.0.2/mx4j-3.0.2.tar.gz/download"
default['cassandra']['jna_url'] = "http://java.net/projects/jna/sources/svn/content/tags/3.3.0/jnalib/dist/jna.jar?rev=1208"

default['cassandra']['version'] = "1.0.7-1"

# cassandra configuration
default['cassandra']['max_heap_size'] = "10G"
default['cassandra']['heap_newsize'] = "800M"

# array of environments used if you have multiple cassandra clusters and you want to define a cluster's environments for building the Nagios NRPE monitor
default['cassandra']['cluster_chef_environments'] = []

# Currently unused attributes that will be part of the new full configuration recipe
default['cassandra']['auto_bootstrap'] = false
default['cassandra']['hinted_handoff_enabled'] = true
default['cassandra']['max_hint_window_in_ms'] = 3600000
default['cassandra']['hinted_handoff_throttle_delay_in_ms'] = 50
default['cassandra']['authenticator'] = "org.apache.cassandra.auth.AllowAllAuthenticator"
default['cassandra']['authority'] = "org.apache.cassandra.auth.AllowAllAuthority"
default['cassandra']['partitioner'] = "org.apache.cassandra.dht.RandomPartitioner"
default['cassandra']['data_file_directories'] =  "/var/lib/cassandra/data"
default['cassandra']['commitlog_directory'] = "/var/lib/cassandra/commitlog"
default['cassandra']['saved_caches_directory'] = "/var/lib/cassandra/saved_caches"
default['cassandra']['commitlog_rotation_threshold_in_mb'] = 128
default['cassandra']['commitlog_sync'] = "periodic"
default['cassandra']['commitlog_sync_period_in_ms'] = 10000
default['cassandra']['flush_largest_memtables_at'] = 0.75
default['cassandra']['reduce_cache_sizes_at'] = 0.85
default['cassandra']['reduce_cache_capacity_to'] = 0.6
default['cassandra']['seed_provider_class_name'] = "org.apache.cassandra.locator.SimpleSeedProvider"
default['cassandra']['disk_access_mode'] = "auto"
default['cassandra']['concurrent_reads'] = 80
default['cassandra']['concurrent_writes'] = 64
default['cassandra']['memtable_flush_queue_size'] = 4
default['cassandra']['memtable_flush_writers'] = 1
default['cassandra']['sliced_buffer_size_in_kb'] = 64
default['cassandra']['storage_port'] = 7000
default['cassandra']['rpc_port'] = 9160
default['cassandra']['rpc_keepalive'] = true
default['cassandra']['rpc_server_type'] = "sync"
default['cassandra']['thrift_framed_transport_size_in_mb'] = 15
default['cassandra']['thrift_max_message_length_in_mb'] = 16
default['cassandra']['incremental_backups'] = false
default['cassandra']['snapshot_before_compaction'] = false
default['cassandra']['column_index_size_in_kb'] = 64
default['cassandra']['in_memory_compaction_limit_in_mb'] = 64
default['cassandra']['compaction_throughput_mb_per_sec'] = 16
default['cassandra']['compaction_preheat_key_cache'] = true
default['cassandra']['rpc_timeout_in_ms'] = 10000
default['cassandra']['phi_convict_threshold'] = 8
default['cassandra']['endpoint_snitch'] = "org.apache.cassandra.locator.PropertyFileSnitch"
default['cassandra']['dynamic_snitch_badness_threshold'] = 0.0
default['cassandra']['request_scheduler'] = "org.apache.cassandra.scheduler.NoScheduler"
default['cassandra']['index_interval'] = 128
default['cassandra']['memtable_total_space_in_mb'] = 4096
default['cassandra']['multithreaded_compaction'] = false
default['cassandra']['commitlog_total_space_in_mb'] = 3072
default['cassandra']['jna_location'] = "800M"

# Cassandra data backup attributes
default['cassandra']['backup']['num_backups_retained'] = 7
default['cassandra']['backup']['backup_nfs_mount'] = nil
default['cassandra']['backup']['mount_path'] = nil
