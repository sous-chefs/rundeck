Description
===========
Install Kafka Mirror Maker Service to mirror Kaka topics from 1 broker to another.

The target and source environments should be defined as node attributes to allow for
flexibility in controlling what machines mirror what environments.

Requirements
============
ondemand_server
java
runit

Attributes
==========
*** Mirrormaker specific attributes
['wt_kafka_mm']['user'] - The user 
['wt_kafka_mm']['group'] - The group
['wt_kafka_mm']['java_opts'] - Java options
['wt_kafka_mm']['jmx_port'] - JMX port
['wt_kafka_mm']['topic_white_list'] - A regular expression denoting the topics to mirror

*** These are used to form the zk connect string to identify the target kafka brokers
['wt_kafka_mm']['target']['env']
['wt_kafka_mm']['target']['zkpath']

*** These are used to form the zk connect string to identify the source kafka brokers
[wt_kafka_mm][sources]

Example node attributes for target and sources. Note that there can only be a single
target but multiple sources
"wt_kafka_mm": {
      "target": {
        "env": "H",
        "dc": "Lab"# "wt_kafka_mm": {
      "sources": {
        "G": "Lab_G_brokers"
      },
      "target": {
        "env": "H",
        "zkpath": "Lab_H_brokers"
      }
    },
  
      "sources": {
        "M": "Lab",
        "G": "Lab"
      }
    },


*** Other referenced attributes
['wt_common']['log_dir_linux'] - Log directory
['wt_common']['install_dir_linux'] - Install directory

['java']['java_home'] - Location where java is installed

['zookeeper']['client_port'] - Port used to connect to zookeeper

['kafka']['chroot_suffix'] - Used to form the zookeeper connection path
['kafka']['version'] - Mirrormaker is a utility within kafka. Needs to know what version to pull down
['kafka']['download_url'] - Location of the kafka repository



Usage
=====
deploy_build=true chef-client

A service will be created for each of the source environments specified. They will be named
mirrormaker_<src_env> 
