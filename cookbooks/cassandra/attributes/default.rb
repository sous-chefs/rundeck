# Needed for the Chef script to function properly
default[:setup][:deployment] = "08x"    # Choices are "07x", or "08x"
default[:setup][:cluster_size] = 4
default[:setup][:current_role] = "cassandra"

# A unique name is preferred to stop the risk of different clusters joining each other
default[:cassandra][:cluster_name] = "Cassandra Cluster"

# It is best to have the commit log and the data
# directory on two seperate drives
default[:cassandra][:commitlog_dir] = "/var/lib"
default[:cassandra][:data_dir] = "/var/lib"


# Advanced Cassandra settings
default[:cassandra][:token_position] = false
default[:cassandra][:initial_token] = false
default[:cassandra][:seed] = false
default[:cassandra][:rpc_address] = false
default[:cassandra][:confPath] = "/etc/cassandra/"

default[:internal][:prime] = true
