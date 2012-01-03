#
# Cookbook Name:: cassandra
# Recipe:: optional_packages
#
# Copyright 2011, DataStax
#
# Apache License
#

###################################################
# 
# Install Optional Packages
# 
###################################################

# Addtional optional programs/utilities
case node[:platform]
  when "ubuntu", "debian"
    package "pssh"
    package "xfsprogs"
    package "maven2"
    package "git-core"

    # Addtional optional program for RAID management
    package "mdadm" do
      options "--no-install-recommends"
      action :install
    end
  when "centos", "redhat", "fedora"
    # Addtional optional program for RAID management
    package "mdadm"
    package "git"
end

package "python"
package "htop"
package "iftop"
package "pbzip2"
package "ant"
package "emacs"
package "sysstat"
package "zip"
package "unzip"
package "binutils"
package "ruby"
package "openssl"
package "ant"
package "curl"
