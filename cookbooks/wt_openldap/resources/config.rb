#
# Cookbook Name:: wt_openldap
# Resource:: config
#
# Copyright 2013, Webtrends Inc.
#
# All rights reserved - Do Not Redistribute
#

actions :create
default_action :create

attribute :attribute, :kind_of => String, :name_attribute => true
attribute :dn,        :kind_of => String, :default => 'cn=config'
attribute :value,     :kind_of => String, :required => true

attr_accessor :exists

# no need to expose filter as a resource attribute (yet)
#def filter (arg = nil)
#	if arg == nil
#		arg = self.dn[/^(.*),cn=config$/, 1] unless self.dn.nil?
#	end
#	set_or_return(:filter, arg, :kind_of => String)
#end
