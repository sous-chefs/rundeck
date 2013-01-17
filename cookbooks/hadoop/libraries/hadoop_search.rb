#
# Cookbook Name:: hadoop
# Library:: hadoop_search
# Author:: David Dvorak (<david.dvorak@webtrends.com>)
#
# Copyright 2012, Webtrends Inc.
#
# All rights reserved - Do Not Redistribute
#

module HadoopSearch

	def hadoop_search(role, limit = 1000, search_chefenv = nil)

		search_timeout   = 60 # seconds
		search_chefenv ||= node.chef_environment

		Chef::Log.info "hadoop_cluster_name: #{node[:hadoop][:cluster_name]}"
		Chef::Log.info "search_chefenv: #{search_chefenv}"

		results = Array.new

		if node[:hadoop][:cluster_name] == 'default'

			# search for nodes with default cluster name
			query =  "chef_environment:#{search_chefenv}"
			query << " AND role:#{role}"
			query << " AND hadoop_cluster_name:#{node[:hadoop][:cluster_name]}"
			Chef::Log.info "hadoop_search: #{query}"

			i = 0
			while results.count == 0 && i < search_timeout
				search(:node, query).each {|n| results << n[:fqdn] }
				if results.count == 0
					Chef::Log.warn "hadoop_search: no results, sleeping..."
					i += 5
					sleep 5
				end
			end

			# search for nodes that have no cluster name
			query =  "chef_environment:#{search_chefenv}"
			query << " AND role:#{role}"
			query << " AND NOT hadoop_cluster_name:*"
			Chef::Log.info "hadoop_search: #{query}"

			search(:node, query).each {|n| results << n[:fqdn] }

		else

			# search for nodes with a non-default cluster name
			query =  "chef_environment:#{search_chefenv}"
			query << " AND role:#{role}"
			query << " AND hadoop_cluster_name:#{node[:hadoop][:cluster_name]}"
			Chef::Log.info "hadoop_search: #{query}"

			i = 0
			while results.count == 0 && i < search_timeout
				search(:node, query).each {|n| results << n[:fqdn] }
				if results.count == 0
					Chef::Log.warn "hadoop_search: no results, sleeping..."
					i += 5
					sleep 5
				end
			end

		end

		Chef::Log.warn  "hadoop_search: slept for #{i} seconds." if i > 0
		Chef::Log.debug "hadoop_search: #{role}: nodes found: #{results.count}"
		if results.count == 0 || results.count > limit
			Chef::Log.error "hadoop_search: #{role}: nodes found: #{results.count}"
		else
			Chef::Log.info "hadoop_search: #{role}: #{results.first}"
		end

		results

	end

end

class Chef::Recipe; include HadoopSearch; end
