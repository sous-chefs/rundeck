#
# Cookbook Name:: wt_base
# Library:: data
# Author:: David Dvorak (<david.dvorak@webtrends.com>)
#
# Copyright 2012, Webtrends Inc.
#
# All rights reserved - Do Not Redistribute
#

# get authorization data bag
def wt_auth
  data_bag_item('authorization', node.chef_environment)
end

# get wt_common data from attributes and data bag
def wt_config
  node['wt_common'].to_hash.merge(wt_auth['wt_common'])
end

# get current cookbook attributes
def cb_config
  node[cookbook_name]
end