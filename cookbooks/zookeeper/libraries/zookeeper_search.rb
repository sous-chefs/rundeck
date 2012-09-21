#
# Cookbook Name:: zookeeper
# Library:: zookeeper_search
# Author:: David Dvorak (<david.dvorak@webtrends.com>)
#
# Copyright 2012, Webtrends Inc.
#
# All rights reserved - Do Not Redistribute
#

module ZookeeperSearch

	def zookeeper_search(role, limit = 1000)

		search_timeout = 60 

		Chef::Log.info "zookeeper_cluster_name: #{node[:zookeeper][:cluster_name]}"

		node.save # needed so attributes are populated

		results = Array.new

		if node[:zookeeper][:cluster_name] == 'default'

			# search for nodes with default cluster name
			query =  "chef_environment:#{node.chef_environment}"
			query << " AND role:#{role}"
			query << " AND zookeeper_cluster_name:#{node[:zookeeper][:cluster_name]}"

			i = 0
			while results.count == 0 && i < search_timeout 
				search(:node, query).each {|n| results << n[:fqdn] }
				if results.count == 0
					Chef::Log.warn "no results, sleeping"
					i += 5
					sleep 5
				end
			end

			# search for nodes that have no cluster name
			query =  "chef_environment:#{node.chef_environment}"
			query << " AND role:#{role}"
			query << " AND NOT zookeeper_cluster_name:*"
			search(:node, query).each {|n| results << n[:fqdn] }

		else

			# search for nodes with a non-default cluster name
			query =  "chef_environment:#{node.chef_environment}"
			query << " AND role:#{role}"
			query << " AND zookeeper_cluster_name:#{node[:zookeeper][:cluster_name]}"

			i = 0
			while results.count == 0 && i < search_timeout
				search(:node, query).each {|n| results << n[:fqdn] }
				if results.count == 0
					Chef::Log.warn "no results, sleeping"
					i += 5
					sleep 5
				end
			end

		end

		if results.count == 0 || results.count > limit
			Chef::Log.error "zookeeper_search: #{role}: nodes found: #{results.count}"
		end
		Chef::Log.debug "zookeeper_search: #{role}: nodes found: #{results.count}"
		Chef::Log.warn  "zookeeper_search: slept for #{i} seconds." if i > 0
		
		results

	end

end

class Chef::Recipe; include ZookeeperSearch; end
