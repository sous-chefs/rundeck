#
# Author:: David Dvorak (<david.dvorak@webtrends.com>)
# Cookbook Name:: wt_example
# Attribute:: default
#
# Copyright 2012, Webtrends Inc.
#

# display_name should match the registered DisplayName
# ref:  HKLM\Software\<Wow6432Node>\Microsoft\Windows\CurrentVersion\Uninstall
default['wt_example']['display_name'] = 'WebTrends Common Lib'

# msi filename
default['wt_example']['msifile'] = 'WebTrends Common Lib.msi'

