#
# Cookbook Name:: wt_base
# Provider:: icacls
# Author:: David Dvorak (<david.dvorak@webtrends.com>)
#
# Copyright 2012, Webtrends Inc.
#
# All rights reserved - Do Not Redistribute
#

include Chef::Mixin::ShellOut

action :grant do
  Chef::Log.debug("icacls.exe grant #{@new_resource.path} => #{@new_resource.user} => #{@new_resource.perm}")
  if @new_resource.user == nil
    raise Chef::Exceptions::AttributeNotFound, "user or group could not be determined"
  end
  case @new_resource.perm
    when :full
      perm = "(oi)(ci)(f)"
    when :modify
      perm = "(oi)(ci)(m)"
    when :read
      perm = "(oi)(ci)(rx)"
    else
      raise Chef::Exceptions::AttributeNotFound, "perm could not be determined, please use :full, :modify or :read"
  end
  shell_out!("icacls \"#{@new_resource.path}\" /grant:r \"#{@new_resource.user}\":#{perm}")
end

action :remove do
  Chef::Log.debug("icacls remove #{@new_resource.path} => #{@new_resource.user}")
  if @new_resource.user == nil
    raise Chef::Exceptions::AttributeNotFound, "user or group could not be determined"
  end
  shell_out!("icacls.exe \"#{@new_resource.path}\" /remove \"#{@new_resource.user}\" /t /c /l /q")
end

action :run do
  Chef::Log.debug("icacls run #{@new_resource.options}")
  if @new_resource.options == nil
    raise Chef::Exceptions::AttributeNotFound, "options need to be provided"
  end
  shell_out!("icacls.exe #{@new_resource.options}")
end