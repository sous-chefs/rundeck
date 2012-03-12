#
# Author:: David Dvorak(<david.dvorakd@webtrends.com>)
# Cookbook Name:: wt_base
# Resource:: icacls
#
# Copyright:: 2012, Webtrends Inc.
#
# All rights reserved - Do Not Redistribute
#

actions :grant, :remove, :run

attribute :path, :kind_of => String, :name_attribute => true
attribute :user, :kind_of => String, :default => nil
attribute :perm, :kind_of => Symbol, :default => nil, :equal_to =>[:full, :modify, :read]
attribute :options, :kind_of => String, :default => nil
