maintainer       "Webtrends Inc."
maintainer_email "david.dvorak@webtrends.com"
license          "All rights reserved"
description      "Installs/Configures wt_labserver"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.1.0"

%w{ ubuntu centos windows }.each do |os|
  supports os
end
