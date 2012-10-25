#
# Author:: Sean McNamara (<sean.mcnamara@webtrends.com>)
# Cookbook Name:: shark
# Attribute:: default
#
# Copyright 2012, Webtrends Inc.
#

default['shark']['version'] = "0.2"
default['shark']['download_url'] = "https://github.com/downloads/amplab/shark"
default['shark']['install_dir'] = "/opt/shark"

default['shark']['hive']['version'] = "0.9.0"

default['shark']['hadoop']['version'] = "1.0.4"
default['shark']['hadoop']['download_url'] = "http://apache.cs.utah.edu/hadoop/common"
