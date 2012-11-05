#
# Resource:: Minitest
#
# Copyright 2012, Webtrends, Inc.
# ALl rights reserved

actions :run, :nothing

attribute :cookbook_name, :kind_of => String,       :name_attribute => true
attribute :recipe_name,   :kind_of => String
attribute :mode,          :kind_of => /^0\d{3,4}$/, :default => 00755
attribute :owner,         :kind_of => String,       :default => "root"
attribute :group,         :kind_of => String,       :default => "root"
attribute :path,          :kind_of => String,       :default => "/var/chef/cache"
attribute :recipe_type,   :kind_of => String,       :default => "test"

default_action :run

def initialize(*args)
  super
  @action = :run
end
