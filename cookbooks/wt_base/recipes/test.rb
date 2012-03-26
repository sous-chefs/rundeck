#
# Author:: David Dvorak (<david.dvorak@webtrends.com>)
# Cookbook Name:: wt_base
# Recipe:: test
#
# Copyright 2012, Webtrends Inc.
#
# All rights reserved - Do Not Redistribute
#

if not platform?("ubuntu")
	log "dvorak - this not is ubuntu"
	return
else
	log "dvorakd, this is ubuntu"
end

log "don't log this message"
