#
# Author:: David Dvorak (<david.dvorak@webtrends.com>)
# Cookbook Name:: wt_base
# Recipe:: test
#
# Copyright 2012, Webtrends Inc.
#
# All rights reserved - Do Not Redistribute
#

wt_base_icacls "d:\\wrs" do
	action :grant
	user "STAGINGDMZ\\wtSystem"
	perm :read
end

wt_base_icacls "d:\\wrs" do
	action :remove
	user "STAGINGDMZ\\wt"
end 

wt_base_icacls "d:\\wrs" do
	action :run
	options "d:\\wrs /deny STAGINGDMZ\\wtUI:(D)"
end
