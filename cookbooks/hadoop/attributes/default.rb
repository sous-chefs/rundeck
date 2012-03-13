

default[:hadoop][:version] = "1.0.0"
default[:hadoop][:install_stage_dir] = "/usr/local/share/hadoop"


# hdfs-site.xml
# see: http://hadoop.apache.org/common/docs/current/hdfs-default.html
default[:hadoop][:dfs][:block_size] = 67108864
default[:hadoop][:dfs][:name_dir] = "/var/lib/hadoop/hdfs/namenode"
default[:hadoop][:dfs][:data_dir] = "/data/hadoop/hdfs/datanode"
default[:hadoop][:dfs][:datanode_handler_count] = 3
default[:hadoop][:dfs][:namenode_handler_count] = 10
default[:hadoop][:dfs][:datanode_du_reserved] = 0
default[:hadoop][:dfs][:replication] = 3
default[:hadoop][:dfs][:permissions] = "true"
default[:hadoop][:dfs][:datanode_max_xcievers] = 4096


# mapred-site.xml
# see: http://hadoop.apache.org/common/docs/current/mapred-default.html
default[:hadoop][:mapred][:child_java_opts] = "-server -Xmx640m -Djava.net.preferIPv4Stack=true"
default[:hadoop][:mapred][:job_tracker_handler_count] = 10
default[:hadoop][:mapred][:reduce_tasks] = 1
default[:hadoop][:mapred][:local_dir] = "${hadoop.tmp.dir}/mapred/local"
default[:hadoop][:mapred][:tasktracker_map_tasks_maximum] = 2
default[:hadoop][:mapred][:tasktracker_reduce_tasks_maximum] = 2
default[:hadoop][:mapred][:child_ulimit] = "8388608"
default[:hadoop][:mapred][:map_tasks_speculative_execution] = "false"
default[:hadoop][:mapred][:reduce_tasks_speculative_execution] =  "false"
default[:hadoop][:mapred][:job_reuse_jvm_num_tasks] = 1
default[:hadoop][:mapred][:io_sort_factor] = 10
default[:hadoop][:mapred][:io_sort_mb] = 100


# core-site.xml
# see: http://hadoop.apache.org/common/docs/current/core-default.html
default[:hadoop][:core][:io_file_buffer_size] = 4096
default[:hadoop][:core][:fs_checkpoint_dir] = "${hadoop.tmp.dir}/dfs/namesecondary"
default[:hadoop][:core][:fs_trash_interval] = 360


# hadoop-env.sh
default[:hadoop][:env][:HADOOP_HEAPSIZE] = 1000
default[:hadoop][:env][:java_net_preferIPv4Stack] = "true"
default[:hadoop][:env][:HADOOP_OPTS] = ""

