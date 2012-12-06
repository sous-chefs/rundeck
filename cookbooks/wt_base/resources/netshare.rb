#
# Cookbook Name:: wt_base
# Resource:: netshare
# Author:: David Dvorak(<david.dvorakd@webtrends.com>)
#
# Copyright 2012, Webtrends Inc.
#
# All rights reserved - Do Not Redistribute
#

actions :grant, :remove, :run
default_action :run

attribute :name,    :kind_of => String, :name_attribute => true
attribute :path,    :kind_of => String, :default => nil
attribute :user,    :kind_of => String, :default => nil
attribute :users,   :kind_of => [ Array ], :default => nil
attribute :perm,    :kind_of => Symbol, :default => :read, :equal_to =>[:full, :modify, :read]
attribute :remark,  :kind_of => String, :default => nil
attribute :returns, :kind_of => [Integer, Array], :default => 0
attribute :options, :kind_of => String, :default => nil
