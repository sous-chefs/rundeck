maintainer       "DataStax"
maintainer_email "joaquin@datastax.com"
license          "Apache License"
description      "Install and configure Cassandra in a multi-node environment"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.1.4"
depends          "apt"
recipe           "cassandra::default", "Runs the full list of scripts needed."
recipe           "cassandra::setup_repos", "Sets up the Apache Cassandra and DataStax Repos."
recipe           "cassandra::required_packages", "Installs required packages, primarily sun-java-sdk."
recipe           "cassandra::optional_packages", "Installs extra tools for Cassandra maintenance."
recipe           "cassandra::install", "Installs the actual Cassandra package."
recipe           "cassandra::additional_settings", "Additional settings for optimal performance for the cluster."
recipe           "cassandra::token_generation", "Generates the token positions for the cluster."
recipe           "cassandra::create_seed_list", "Generates the seed lists for the cluster."
recipe           "cassandra::write_configs", "Writes the configurations for Cassandra."
recipe           "cassandra::restart_service", "Restarts the Cassandra service."

attribute "setup",
  :display_name => "Setup Configurations",
  :description => "Hash of Setup Configurations",
  :type => "hash"

attribute "setup/deployment",
  :display_name => "Deployment Version",
  :description => "The deployment version for Cassandra. Choices are '07x', or '08x'",
  :default => "08x"

attribute "setup/cluster_size",
  :display_name => "Cluster Size",
  :description => "Total number of nodes in the cluster",
  :default => "4"

attribute "setup/current_role",
  :display_name => "Current Role Being Assigned",
  :description => "The role that the cluster is being assigned",
  :default => "cassandra"




attribute "cassandra",
  :display_name => "Cassandra",
  :description => "Hash of Cassandra attributes",
  :type => "hash"

attribute "cassandra/cluster_name",
  :display_name => "Cassandra Cluster Name",
  :description => "Keeps clusters together, not allowing servers from other clusters to talk",
  :default => "Cassandra Cluster"

attribute "cassandra/commitlog_dir",
  :display_name => "Cassandra Commit Log Directory",                                                                                                                                                                        
  :description => "The location for the commit log (preferably on it's own drive or RAID0 device)",
  :default => "/var/lib"

attribute "cassandra/data_dir",
  :display_name => "Cassandra Data Directory",                                                                                                                                                                        
  :description => "The location for the data directory (preferably on it's own drive or RAID0 device)",
  :default => "/var/lib"

attribute "cassandra/token_position",
  :display_name => "Cassandra Initial Token Position",
  :description => "For use when adding a node that may have previously failed or been destroyed",
  :default => "false"

attribute "cassandra/initial_token",
  :display_name => "Cassandra Initial Token",
  :description => "The standard initial token",
  :default => "false"

attribute "cassandra/seed",
  :display_name => "Cassandra Seed Server",                                                                                                                                                                        
  :description => "The comma seperated list of seeds (Make sure to include one seed from each datacenter minimum)",
  :default => "false"

attribute "cassandra/rpc_address",
  :display_name => "Cassandra RPC Address",                                                                                                                                                                        
  :description => "The address to bind the Thrift RPC service to (False sets RPC Address to the private IP)",
  :default => "false"

attribute "cassandra/confPath",
  :display_name => "Cassandra Settings Path",                                                                                                                                                                        
  :description => "The path for cassandra.yaml and cassandra-env.sh",
  :default => "/etc/cassandra/"



attribute "internal",
  :display_name => "Internal Hash",
  :description => "Hash of Internal attributes",
  :type => "hash"

attribute "internal/prime",
  :display_name => "Internal Hash Primer",
  :description => "Primes a datastore for internal use only",
  :default => "true"
