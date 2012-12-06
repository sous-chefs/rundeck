#
# Cookbook Name:: wt_base
# Resource:: poddetails
# Author:: David Dvorak(<david.dvorakd@webtrends.com>)
#
# Copyright 2012, Webtrends Inc.
#
# All rights reserved - Do Not Redistribute
#

actions :run
default_action :run

attribute :hostname,       :kind_of => String, :name_attribute => true
attribute :pod,            :kind_of => String, :required => true
attribute :role,           :kind_of => String, :required => true
attribute :version,        :kind_of => String, :default => nil
attribute :selectversion,  :kind_of => String, :default => nil
attribute :branch,         :kind_of => String, :default => nil
attribute :build,          :kind_of => String, :default => nil
attribute :builddir,       :kind_of => String, :default => nil
attribute :keyfile,        :kind_of => String, :default => nil
attribute :status,         :kind_of => String, :default => nil
attribute :credential,     :kind_of => String, :default => nil
attribute :password,       :kind_of => String, :default => nil
attribute :usedefaultcred, :default => false
