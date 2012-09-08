#
# Cookbook Name:: hive
# Library:: hive_attributes
# Author:: David Dvorak (<david.dvorak@webtrends.com>)
#
# Copyright 2012, Webtrends Inc.
#
# All rights reserved - Do Not Redistribute
#

module HiveAttributes

	def hive_attrib(*keys)

		raise ArgumentError, 'Requires 1 or more arguments.' unless keys.length > 0

		cluster_name = construct_attributes[:hive][:cluster_name]
		Chef::Log.debug "hive_attrib: cluster_name: #{cluster_name}"

		# compose call to get hive default attribute
		default_call = "construct_attributes[:hive][:default]"
		keys.each {|k| default_call << "[:#{k}]" }

		# get hive cluster_name attribute if it exists, otherwise get hive default attribute
		if eval("construct_attributes[:hive].attribute?(cluster_name)")
			cluster_keys = "[:hive][cluster_name]"
			count = 0
			keys.each do |k|
				break unless eval("construct_attributes#{cluster_keys}.attribute?(:#{k})")
				cluster_keys << "[:#{k}]"
				count += 1
			end
			if count == keys.length
				cluster_call = "construct_attributes#{cluster_keys}"
				Chef::Log.info "hive_attrib: cluster_call: #{cluster_call}"
				eval(cluster_call)
			else
				Chef::Log.info "hive_attrib: default_call: #{default_call}"
				eval(default_call)
			end
		else
			Chef::Log.info "hive_attrib: default_call: #{default_call}"
			eval(default_call)
		end

	end

end

class Chef::Node; include HiveAttributes; end
