#
# Cookbook Name:: hbase
# Library:: hbase_search 
# Author:: David Dvorak (<david.dvorak@webtrends.com>)
#
# Copyright 2012, Webtrends Inc.
#
# All rights reserved - Do Not Redistribute
#

module HbaseSearch

	def hbase_search(role, limit = 1000)

		search_timeout = 60 # seconds

		Chef::Log.info "hbase_cluster_name: #{node[:hbase][:cluster_name]}"

		results = Array.new

		if node[:hbase][:cluster_name] == 'default'

			# search for nodes with default cluster name
			query =  "chef_environment:#{node.chef_environment}"
			query << " AND roles:#{role}"
			query << " AND hbase_cluster_name:#{node[:hbase][:cluster_name]}"
			Chef::Log.info "hbase_search: #{query}"

			i = 0
			while results.count == 0 && i < search_timeout
				search(:node, query).each {|n| results << n[:fqdn] }
				if results.count == 0
					Chef::Log.warn "hbase_search: no results, sleeping..."
					i += 5
					sleep 5
				end
			end

			# search for nodes that have no cluster name
			query =  "chef_environment:#{node.chef_environment}"
			query << " AND roles:#{role}"
			query << " AND NOT hbase_cluster_name:*"
			Chef::Log.info "hbase_search: #{query}"

			search(:node, query).each {|n| results << n[:fqdn] }

		else

			# search for nodes with a non-default cluster name
			query =  "chef_environment:#{node.chef_environment}"
			query << " AND roles:#{role}"
			query << " AND hbase_cluster_name:#{node[:hbase][:cluster_name]}"
			Chef::Log.info "hbase_search: #{query}"

			i = 0
			while results.count == 0 && i < search_timeout
				search(:node, query).each {|n| results << n[:fqdn] }
				if results.count == 0
					Chef::Log.warn "hbase_search: no results, sleeping..."
					i += 5
					sleep 5
				end
			end

		end

		Chef::Log.warn  "hbase_search: slept for #{i} seconds." if i > 0
		Chef::Log.debug "hbase_search: #{role}: nodes found: #{results.count}"
		if results.count == 0 || results.count > limit
			Chef::Log.error "hbase_search: #{role}: nodes found: #{results.count}"
		else
			Chef::Log.info "hbase_search: #{role}: #{results.first}"
		end

		results

	end

end

class Chef::Recipe; include HbaseSearch; end
