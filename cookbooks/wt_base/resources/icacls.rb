#
# Cookbook Name:: wt_base
# Resource:: icacls
# Author:: David Dvorak(<david.dvorakd@webtrends.com>)
#
# Copyright 2012, Webtrends Inc.
#
# All rights reserved - Do Not Redistribute
#

actions :grant, :remove, :run
default_action :grant

attribute :path, :kind_of => String, :name_attribute => true
attribute :user, :kind_of => String, :default => nil
attribute :perm, :kind_of => Symbol, :default => nil, :equal_to =>[:full, :modify, :read]
attribute :options, :kind_of => String, :default => nil
