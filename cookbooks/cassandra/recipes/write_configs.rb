#
# Cookbook Name:: cassandra
# Recipe:: write_configs
#
# Copyright 2011, DataStax
#
# Apache License
#

###################################################
# 
# Write Configs and Start Services
# 
###################################################

execute "sudo mkdir -p #{node[:cassandra][:data_dir]}"
execute "sudo mkdir -p #{node[:cassandra][:commitlog_dir]}"
execute "sudo chown -R #{node[:internal][:package_user]}:#{node[:internal][:package_user]} #{node[:cassandra][:data_dir]}"
execute "sudo chown -R #{node[:internal][:package_user]}:#{node[:internal][:package_user]} #{node[:cassandra][:commitlog_dir]}"

ruby_block "buildCassandraEnv" do
  block do
    filename = node[:cassandra][:confPath] + "cassandra-env.sh"
    cassandraEnv = File.read(filename)
    cassandraEnv = cassandraEnv.gsub(/# JVM_OPTS="\$JVM_OPTS -Djava.rmi.server.hostname=<public name>"/, "JVM_OPTS=\"\$JVM_OPTS -Djava.rmi.server.hostname=#{node[:cloud][:private_ips].first}\"")
    File.open(filename, 'w') {|f| f.write(cassandraEnv) }
  end
  action :create
  notifies :run, resources(:execute => "clear-data"), :immediately
end

ruby_block "buildCassandraYaml" do
  block do
    filename = node[:cassandra][:confPath] + "cassandra.yaml"
    cassandraYaml = File.read(filename)
    cassandraYaml = cassandraYaml.gsub(/cluster_name:.*/,               "cluster_name: '#{node[:cassandra][:cluster_name]}'")
    cassandraYaml = cassandraYaml.gsub(/initial_token:.*/,              "initial_token: #{node[:cassandra][:initial_token]}")
    cassandraYaml = cassandraYaml.gsub(/\/.*\/cassandra\/data/,         "#{node[:cassandra][:data_dir]}/cassandra/data")
    cassandraYaml = cassandraYaml.gsub(/\/.*\/cassandra\/commitlog/,    "#{node[:cassandra][:commitlog_dir]}/cassandra/commitlog")
    cassandraYaml = cassandraYaml.gsub(/\/.*\/cassandra\/saved_caches/, "#{node[:cassandra][:data_dir]}/cassandra/saved_caches")
    cassandraYaml = cassandraYaml.gsub(/listen_address:.*/,             "listen_address: #{node[:cloud][:private_ips].first}")

    if node[:cassandra][:rpc_address]
      cassandraYaml = cassandraYaml.gsub(/rpc_address:.*/,                "rpc_address: #{node[:cassandra][:rpc_address]}")
    else
      cassandraYaml = cassandraYaml.gsub(/rpc_address:.*/,                "rpc_address: #{node[:cloud][:private_ips].first}")
    end

    # Cassandra 0.7.x has a slightly different Yaml
    if node[:setup][:deployment] == "07x"
      cassandraYaml = cassandraYaml.gsub(/- 127.0.0.1/,                 "- #{node[:cassandra][:seed]}")
    else
      cassandraYaml = cassandraYaml.gsub(/seeds:.*/,                    "seeds: \"#{node[:cassandra][:seed]}\"")
    end
    
    File.open(filename, 'w') {|f| f.write(cassandraYaml) }
  end
  action :create
end
