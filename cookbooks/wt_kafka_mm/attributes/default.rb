default['wt_mirrormaker']['user']         = "kafka"
default['wt_mirrormaker']['group']        = "kafka"
default['wt_mirrormaker']['java_opts']    = "-Xms1024m -Djava.net.preferIPv4Stack=true"

#Kafka
default[:kafka][:version] = "0.7.0"
default[:kafka][:download_url] = nil

default[:kafka][:install_dir] = "/opt/kafka"
default[:kafka][:data_dir] = "/var/kafka"
default[:kafka][:log_dir] = "/var/log/kafka"

default[:kafka][:broker_id] = nil
default[:kafka][:broker_host_name] = nil
default[:kafka][:port] = 9092
default[:kafka][:threads] = nil
default[:kafka][:log_flush_interval] = 10000
default[:kafka][:log_flush_time_interval] = 1000
default[:kafka][:log_flush_scheduler_time_interval] = 1000
default[:kafka][:log_retention_hours] = 168
