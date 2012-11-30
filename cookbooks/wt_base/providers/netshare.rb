#
# Cookbook Name:: wt_base
# Provider:: netshare
# Author:: David Dvorak (<david.dvorak@webtrends.com>)
#
# Copyright 2012, Webtrends Inc.
#
# All rights reserved - Do Not Redistribute
#

#
# Warning:  NetShare only grants access to shares and not to the file system.
#

include Chef::Mixin::ShellOut

action :grant do
  Chef::Log.debug("net share grant name => #{@new_resource.name}, path => #{@new_resource.path}, user => #{@new_resource.user}, perm => #{@new_resource.perm}")

  raise Chef::Exceptions::AttributeNotFound, "path could not be determined" if @new_resource.path.nil?
  raise Chef::Exceptions::AttributeNotFound, "user could not be determined" if @new_resource.user.nil? and @new_resource.users.nil?
  these_users = Array.new
  these_users << { :user => @new_resource.user, :perm => @new_resource.perm } unless @new_resource.user.nil?
  these_users += @new_resource.users unless @new_resource.users.nil?

  cmd_options = ""
  these_users.each do |i| 
    case i[:perm]
      when :full
        perm = "FULL"
      when :modify
        perm = "CHANGE"
      when :read
        perm = "READ"
      else
        raise Chef::Exceptions::AttributeNotFound, "perm could not be determined, please use full, modify or read"
    end
    cmd_options << " /grant:\"#{i[:user]}\",#{perm}"
  end
  cmd = "net share \"#{@new_resource.name}\"=\"#{@new_resource.path}\"" + cmd_options
  cmd << " /remark:\"#{@new_resource.remark}\"" unless @new_resource.remark.nil?
  shell_out!(cmd, :returns => @new_resource.returns)
end

action :remove do
  Chef::Log.debug("net share remove name => #{@new_resource.name}")
  shell_out!("net share \"#{@new_resource.name}\" /delete /y", :returns => @new_resource.returns)
end

action :run do
  Chef::Log.debug("net share run #{@new_resource.options}")
  raise Chef::Exceptions::AttributeNotFound, "options need to be provided" if @new_resource.options.nil?
  shell_out!("net share #{@new_resource.options}", :returns => @new_resource.returns)
end