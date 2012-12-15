name             "zlib"
maintainer       "Opscode, Inc."
maintainer_email "cookbooks@opscode.com"
license          "Apache 2.0"
description      "Installs zlib"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "2.0.0"

recipe "zlib", "Installs zlib development package"

%w{ centos redhat scientific oracle amazon suse fedora arch ubuntu debian mint raspbian }.each do |os|
  supports os
end
