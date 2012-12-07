#
# Cookbook Name:: hadoop
# Attribute:: default
#
# Copyright 2012, Webtrends Inc.
#

# cluster name
default[:hadoop][:cluster_name] = 'default'

# hadoop cluster attributes
default[:hadoop][:default][:version] = '1.0.3-1'
default[:hadoop][:default][:install_dir] = '/usr/share/hadoop'


# hdfs-site.xml
# see: http://hadoop.apache.org/common/docs/current/hdfs-default.html
default[:hadoop][:default][:dfs][:block_size] = 67108864
default[:hadoop][:default][:dfs][:name_dir] = '/var/lib/hadoop/hdfs/namenode'
default[:hadoop][:default][:dfs][:data_dir] = '/data/hadoop/hdfs/datanode'
default[:hadoop][:default][:dfs][:datanode_handler_count] = 3
default[:hadoop][:default][:dfs][:namenode_handler_count] = 10
default[:hadoop][:default][:dfs][:datanode_du_reserved] = 0
default[:hadoop][:default][:dfs][:replication] = 3
default[:hadoop][:default][:dfs][:permissions] = 'true'
default[:hadoop][:default][:dfs][:datanode_max_xcievers] = 4096


# mapred-site.xml
# see: http://hadoop.apache.org/common/docs/current/mapred-default.html
default[:hadoop][:default][:mapred][:child_java_opts] = '-server -Xmx640m -Djava.net.preferIPv4Stack=true'
default[:hadoop][:default][:mapred][:job_tracker_handler_count] = 10
default[:hadoop][:default][:mapred][:reduce_tasks] = 1
default[:hadoop][:default][:mapred][:local_dir] = '${hadoop.tmp.dir}/mapred/local'
default[:hadoop][:default][:mapred][:non_datanode_local_dir] = '${hadoop.tmp.dir}/mapred/local'
default[:hadoop][:default][:mapred][:tasktracker_map_tasks_maximum] = 2
default[:hadoop][:default][:mapred][:tasktracker_reduce_tasks_maximum] = 2
default[:hadoop][:default][:mapred][:child_ulimit] = 8388608
default[:hadoop][:default][:mapred][:map_tasks_speculative_execution] = 'false'
default[:hadoop][:default][:mapred][:reduce_tasks_speculative_execution] =  'false'
default[:hadoop][:default][:mapred][:job_reuse_jvm_num_tasks] = 1
default[:hadoop][:default][:mapred][:io_sort_factor] = 10
default[:hadoop][:default][:mapred][:io_sort_mb] = 100
default[:hadoop][:default][:mapred][:submit_replication] = 10
default[:hadoop][:default][:mapred][:acls_enabled] = 'true'
default[:hadoop][:default][:mapred][:cluster_administrators] = 'hadoop'
default[:hadoop][:default][:mapred][:job_acl_modify] = 'hadoop'
default[:hadoop][:default][:mapred][:job_acl_view] = 'Dr.Who' # The jobtracker webui requires Dr.Who


# mapred-queue-acls.xml
default[:hadoop][:default][:mapred_queue][:acl_submit_job] = 'hadoop'
default[:hadoop][:default][:mapred_queue][:acl_administer_jobs] = 'Dr.Who' # The jobtracker webui requires Dr.Who


# core-site.xml
# see: http://hadoop.apache.org/common/docs/current/core-default.html
default[:hadoop][:default][:core][:io_file_buffer_size] = 4096
default[:hadoop][:default][:core][:fs_checkpoint_dir] = '/var/lib/hadoop/hdfs/backupnamenode'
default[:hadoop][:default][:core][:fs_checkpoint_period] = 3600
default[:hadoop][:default][:core][:fs_trash_interval] = 360
#server running oozie
default[:hadoop][:default][:core][:oozie_proxy_hosts] = 'soozie01'


# hadoop-env.sh
default[:hadoop][:default][:env][:HADOOP_HEAPSIZE] = 1000
default[:hadoop][:default][:env][:java_net_preferIPv4Stack] = 'true'
default[:hadoop][:default][:env][:HADOOP_OPTS] = ''

