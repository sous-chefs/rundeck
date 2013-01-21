#
# Author:: Sean McNamara (<sean.mcnamara@webtrends.com>)
# Cookbook Name:: spark
# Attribute:: default
#
# Copyright 2012, Webtrends Inc.
#

default['spark']['version'] = "0.7.0-SNAPSHOT"

#http://repo.staging.dmz/repo/linux/spark
default['spark']['download_url'] = "http://streaming-sparkmaster01.os.staging.dmz"
default['spark']['install_dir'] = "/opt/spark"

default['spark']['mem']['master'] = "6g"
default['spark']['mem']['slave'] = "6g"