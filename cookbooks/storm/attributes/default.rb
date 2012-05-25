#
# Author:: Sean McNamara (<sean.mcnamara@webtrends.com>)
# Cookbook Name:: storm
# Attribute:: default
#
# Copyright 2012, Webtrends Inc.
#

# cluster identifier
default['storm']['cluster_role'] = ""

# installation attributes
default['storm']['version'] = "0.7.1"
default['storm']['download_url'] = "https://github.com/downloads/nathanmarz/storm/storm-0.7.1.zip"
default['storm']['install_dir'] = "/opt/storm"



######################################################
# attributes for storm.yaml below here


# general storm attributes
default['storm']['localdir'] = "/mnt/storm"
default['storm']['logdir'] = "/var/log/storm"

# supervisor attributes
default['storm']['supervisor']['workers'] = 4

# zookeeper
default['storm']['zookeeper']['root'] = "/storm"



# TODO: Add in all the attributes for storm.yaml

