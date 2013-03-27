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
  Chef::Log.debug("icacls grant #{@new_resource.path} => #{@new_resource.user} => #{@new_resource.perm}")
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
  cmd = "#{icacls} /grant:r \"#{@new_resource.user}\":#{perm}"
  cmd << " /l" if @new_resource.link
  Chef::Log.debug(cmd)
  shell_out!(cmd)
end

action :remove do
  Chef::Log.debug("icacls remove #{@new_resource.path} => #{@new_resource.user}")
  cmd = "#{icacls} /remove \"#{@new_resource.user}\" /t /c /l/ q"
  shell_out!(cmd)
end

private
def icacls
  @icacls ||= begin
    "icacls \"#{@new_resource.path}\""
  end
end