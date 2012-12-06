#
# Cookbook Name:: wt_base
# Resource:: netlocalgroup
# Author:: David Dvorak(<david.dvorakd@webtrends.com>)
#
# Copyright 2012, Webtrends Inc.
#
# All rights reserved - Do Not Redistribute
#

actions :add, :remove
default_action :add

attribute :group,   :kind_of => String, :name_attribute => true
attribute :user,    :kind_of => String, :default => nil
attribute :users,   :kind_of => [ Array ], :default => nil
attribute :returns, :kind_of => [Integer, Array], :default => 0
