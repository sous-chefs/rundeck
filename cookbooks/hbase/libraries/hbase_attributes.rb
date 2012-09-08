#
# Cookbook Name:: hbase
# Library:: hbase_attributes
# Author:: David Dvorak (<david.dvorak@webtrends.com>)
#
# Copyright 2012, Webtrends Inc.
#
# All rights reserved - Do Not Redistribute
#

module HbaseAttributes

	def hbase_attrib(*keys)

		raise ArgumentError, 'Requires 1 or more arguments.' unless keys.length > 0

		cluster_name = construct_attributes[:hbase][:cluster_name]
		Chef::Log.debug "hbase_attrib: cluster_name: #{cluster_name}"

		# compose call to get hbase default attribute
		default_call = "construct_attributes[:hbase][:default]"
		keys.each {|k| default_call << "[:#{k}]" }

		# get hbase cluster_name attribute if it exists, otherwise get hbase default attribute
		if eval("construct_attributes[:hbase].attribute?(cluster_name)")
			cluster_keys = "[:hbase][cluster_name]"
			count = 0
			keys.each do |k|
				break unless eval("construct_attributes#{cluster_keys}.attribute?(:#{k})")
				cluster_keys << "[:#{k}]"
				count += 1
			end
			if count == keys.length
				cluster_call = "construct_attributes#{cluster_keys}"
				Chef::Log.info "hbase_attrib: cluster_call: #{cluster_call}"
				eval(cluster_call)
			else
				Chef::Log.info "hbase_attrib: default_call: #{default_call}"
				eval(default_call)
			end
		else
			Chef::Log.info "hbase_attrib: default_call: #{default_call}"
			eval(default_call)
		end

	end

end

class Chef::Node; include HbaseAttributes; end
