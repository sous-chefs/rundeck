#
# Cookbook Name:: wt_openldap
# Resource:: database
#
# Copyright 2013, Webtrends Inc.
#
# All rights reserved - Do Not Redistribute
#

actions :restore

attribute :source, :kind_of => String, :required => true
attribute :default_password, :kind_of => String, :required => true
