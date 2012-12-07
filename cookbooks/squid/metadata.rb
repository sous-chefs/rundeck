maintainer       "Opscode, Inc."
maintainer_email "matt@opscode.com"
license          "Apache 2.0"
description      "Installs/Configures squid as a simple caching proxy"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.2.0"

%w{ debian ubuntu centos fedora redhat scientific suse amazon oracle}.each do |os|
  supports os
end