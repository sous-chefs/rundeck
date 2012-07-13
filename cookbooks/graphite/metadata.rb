maintainer       "Heavy Water Software Inc."
maintainer_email "ops@hw-ops.com"
license          "Apache 2.0"
description      "Installs/Configures graphite"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.4.0"

%w{ debian ubuntu centos redhat }.each do |os|
  supports os
end

depends  "python"
depends  "apache2"
depends  "memcached"
