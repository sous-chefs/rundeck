#
# Cookbook Name:: wt_publishver
# Resource:: default
# Author:: David Dvorak(<david.dvorakd@webtrends.com>)
#
# Copyright 2013, Webtrends Inc.
#
# All rights reserved - Do Not Redistribute
#

actions :update, :deploy_prereqs

default_action :update

attribute :role,           :kind_of => String, :name_attribute => true
attribute :download_url,   :kind_of => String, :required => true
attribute :key_file,       :kind_of => String, :required => true
attribute :select_version, :kind_of => String, :default => nil
attribute :status,         :kind_of => Symbol, :default => :up, :equal_to =>[:up, :down, :pending, :unknown]

def initialize(*args)
	super
	case node['platform_family']
	when 'windows'
		@provider = lookup_provider_constant(:wt_publishver_windows)
	else
		@provider = lookup_provider_constant(:wt_publishver_linux)
	end
end
