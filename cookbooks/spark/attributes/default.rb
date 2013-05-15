#
# Author:: Sean McNamara (<sean.mcnamara@webtrends.com>)
# Cookbook Name:: spark
# Attribute:: default
#
# Copyright 2012, Webtrends Inc.
#

default['spark']['version'] = "0.8.0"

#http://www.spark-project.org/download-spark-0.7.0-prebuilt-tgz
#http://repo.staging.dmz/repo/linux/spark
default['spark']['download_url'] = "http://streaming-viztoken/"
default['spark']['install_dir'] = "/opt/spark"

default['spark']['mem']['master'] = "6g"
default['spark']['mem']['slave'] = "6g"