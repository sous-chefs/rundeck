name             "collectd"
maintainer       "Noan Kantrowitz"
maintainer_email "nkantrowitz@crypticstudios.com"
license          "Apache 2.0"
description      "Install and configure the collectd monitoring daemon"
version          "1.0.2"

%w{ debian ubuntu centos redhat amazon scientific fedora}.each do |os|
  supports os
end