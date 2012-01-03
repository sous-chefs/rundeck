#
# Cookbook Name:: cassandra
# Recipe:: create_seed_list
#
# Copyright 2011, DataStax
#
# Apache License
#

###################################################
# 
# Build the Seed List
# 
###################################################

# Calculate the seed list if not currently set
if not node[:cassandra][:seed]

  # Find the position of the current node in the ring
  cluster_nodes = search(:node, "roles:#{node[:setup][:current_role]}")
  if node[:cassandra][:token_position] == false
    node[:cassandra][:token_position] = cluster_nodes.count
  end

  # Find all cluster node IP addresses
  cluster_nodes_array = []
  for i in (0..cluster_nodes.count-1)
    cluster_nodes_array << [ cluster_nodes[i][:ohai_time], cluster_nodes[i][:cloud][:private_ips].first ]
  end
  cluster_nodes_array = cluster_nodes_array.sort_by{|node| node[0]}
  Chef::Log.info "Currently seen nodes: #{cluster_nodes_array.inspect}"

  seeds = []

  # Pull the seeds from the chef db
  if cluster_nodes.count == 0

    # Add this node as a seed since this is the first node
    Chef::Log.info "[SEEDS] First node chooses itself."
    seeds << node[:cloud][:private_ips].first
  else
    
    # Add the first node as a seed
    Chef::Log.info "[SEEDS] Add the first node."
    seeds << cluster_nodes_array[0][1]

  end
else

  # Parse the seedlist into an array, if provided
  seeds = node[:cassandra][:seed].gsub(/ /,'').split(",")
end

Chef::Log.info "[SEEDS] Chosen seed(s): " << seeds.inspect

# TODO: Add support for multiple 07x nodes
if node[:setup][:deployment] == "07x"
  node[:cassandra][:seed] = seeds[0]
else
  node[:cassandra][:seed] = seeds.join(",")
end
