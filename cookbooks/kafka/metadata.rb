maintainer        "Webtrends, Inc."
maintainer_email  "ivan.vonnagy@webtrends.com"
license           "Apache 2.0"
description       "Sets up Kafka"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version           "0.0.1"

depends	"java"
depends	"runit"
depends	"zookeeper"

recipe	"kafka::default",		"Base configuration for kafka"

%w{ debian ubuntu centos redhat fedora }.each do |os|
  supports os
end

attribute "kafka/home_dir",
  :display_name => "Kafka Home Directory",
  :description => "Location for Kafka to be located.",
  :default => "/usr/share/kafka"

attribute "kafka/data_dir",
  :display_name => "Kafka Log Directory",
  :description => "Location for Kafka logs.",
  :default => "/usr/share/kafka/kafka-logs"

attribute "kafka/stage_dir",
  :display_name => "Kafka Stage Directory",
  :description => "Location for Kafka to be un-packaged before locating. The attribute is OS specific",
  :default => "/usr/local/share/kafka"

attribute "kafka/log_dir",
  :display_name => "Kafka log4j Directory",
  :description => "Location for Kafka log4j logs.",
  :default => "/var/log/kafka"

attribute "kafka/user",
  :display_name          => "kafka",
  :description           => "The kafka user",
  :default               => "kafka"

attribute "kafka/version",
  :display_name => "Kafka Version",
  :description => "The Kafka version to pull and use",
  :default => "0.7.0"
  
attribute "kafka/zookeeper_recipe",
  :display_name => "Zookeeper Recipe",
  :description => "The recipe used to locate the Zookeeper nodes",
  :default => "zookeeper"

attribute "kafka/zookeeper_client_port",
  :display_name => "Zookeeper Client port",
  :description => "The client port used to access each Zookeeper server",
  :default => "2181"