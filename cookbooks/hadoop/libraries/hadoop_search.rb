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

	def hadoop_search(role, limit = 1000)

		query =  "chef_environment:#{node.chef_environment}"
		query << " AND roles:#{role}"
		query << " AND hadoop_cluster_name:#{node[:hadoop][:cluster_name]}"

		results = Array.new
		search(:node, query).each do |n|
			results << n[:fqdn]
		end

		if (results.length == 0 || results.length > limit)
			Chef::Log.error "hadoop_search: #{role}: nodes found: #{results.length}"
		end

		Chef::Log.debug "hadoop_search: #{role}: nodes found: #{results.length}"

		results.length == 1 ? results.first : results

	end

end

class Chef::Recipe; include HadoopSearch; end
