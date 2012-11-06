#
# Resource:: Minitest
#
# Copyright 2012, Webtrends, Inc.
# ALl rights reserved

actions :run, :nothing

attribute :cookbook_name, :kind_of => String,       :name_attribute => true
attribute :test_name,     :kind_of => String,       :default => "default"
attribute :test_type,     :kind_of => String,       :default => "test"
attribute :mode,          :kind_of => /^0\d{3,4}$/, :default => 00755
attribute :owner,         :kind_of => String,       :default => "root"
attribute :group,         :kind_of => String,       :default => "root"
attribute :path,          :kind_of => String,       :default => "/tmp/chef/tests"

default_action :run

def initialize(*args)
  super
  @action = :run
end
