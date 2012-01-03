#
# Cookbook Name:: cassandra
# Recipe:: token_generation
#
# Copyright 2011, DataStax
#
# Apache License
#

###################################################
# 
# Calculate the Token
# 
###################################################

if node[:cassandra][:initial_token] == false

  # Write tokentool to a an executable file
  cookbook_file "/tmp/tokentool.py" do
    source "tokentool.py"
    mode "0755"
  end

  # Run tokentool accordingly
  execute "/tmp/tokentool.py #{node[:setup][:cluster_size]} > /tmp/tokens" do
    creates "/tmp/tokens"
  end

  # Parse tokentool's output
  ruby_block "ReadTokens" do
    block do
      results = []
      open("/tmp/tokens").each do |line|
        results << line.split(':')[1].strip if line.include? 'Node'
      end

      Chef::Log.info "Setting token to be: #{results[node[:cassandra][:token_position]]}"
      node[:cassandra][:initial_token] = results[node[:cassandra][:token_position]]
    end
  end
end
