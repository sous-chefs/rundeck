#
# Cookbook Name:: wt_base
# Library:: registry_helper
# Author:: David Dvorak (<david.dvorak@webtrends.com>)
#
# Copyright 2012, Webtrends Inc.
#
# All rights reserved - Do Not Redistribute
#

#
# search registry uninstallation data for DisplayName
#
def in_reg_uninstall?(this_display_name)
  found = false
  uninstall_subkey = 'Software\Microsoft\Windows\CurrentVersion\Uninstall'
  Win32::Registry::HKEY_LOCAL_MACHINE.open(uninstall_subkey) do |reg|
    reg.each_key do |key|
      begin
        k = reg.open(key)
        display_name = k["DisplayName"] rescue nil
      rescue Win32::Registry::Error
      end
      if display_name =~ /#{Regexp.quote(this_display_name)}/
        found = true
        break
      end
    end
  end
  return found
end
