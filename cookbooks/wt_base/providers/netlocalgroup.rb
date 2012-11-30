#
# Cookbook Name:: wt_base
# Provider:: netlocalgroup
# Author:: David Dvorak (<david.dvorak@webtrends.com>)
#
# Copyright 2012, Webtrends Inc.
#
# All rights reserved - Do Not Redistribute
#

include Chef::Mixin::ShellOut

action :add do
  Chef::Log.debug("net localgroup add group => #{@new_resource.group}, user => #{@new_resource.user}")
  raise Chef::Exceptions::AttributeNotFound, "user could not be determined" if @new_resource.user.nil? and @new_resource.users.nil?
  these_users = Array.new
  these_users << @new_resource.user  unless @new_resource.user.nil?
  these_users += @new_resource.users unless @new_resource.users.nil?
  cmd_options = ""
  these_users.each do |i| 
    cmd_options << " \"#{i}\""
  end
  cmd = "net localgroup \"#{@new_resource.group}\"" + cmd_options + " /add"
  Chef::Log.debug(cmd)
  shell_out!(cmd, :returns => @new_resource.returns)
end

action :remove do
  Chef::Log.debug("net localgroup remove group => #{@new_resource.group}, user => #{@new_resource.user}")
  raise Chef::Exceptions::AttributeNotFound, "user could not be determined" if @new_resource.user.nil? and @new_resource.users.nil?
  these_users = Array.new
  these_users << @new_resource.user  unless @new_resource.user.nil?
  these_users += @new_resource.users unless @new_resource.users.nil?
  cmd_options = ""
  these_users.each do |i| 
    cmd_options << " \"#{i}\""
  end
  cmd = "net localgroup \"#{@new_resource.group}\"" + cmd_options + " /delete"
  Chef::Log.debug(cmd)
  shell_out!(cmd, :returns => @new_resource.returns)
end