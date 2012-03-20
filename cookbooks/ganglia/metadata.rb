maintainer       "Heavy Water Software Inc."
maintainer_email "darrin@heavywater.ca"
license          "Apache 2.0"
description      "Installs/Configures ganglia"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.1.1"

%w{ debian ubuntu redhat centos fedora }.each do |os|
  supports os
end

recommends "graphite"
suggests "iptables"

