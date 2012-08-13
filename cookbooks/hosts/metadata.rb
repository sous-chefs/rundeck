maintainer       "Tim Smith - Webtrends Inc"
maintainer_email "tim.smith@webtrends.com"
license          "All rights reserved"
description      "Configures the /etc/hosts file"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "1.0.1"

%w{ centos redhat amazon scientific }.each do |os|
  supports os
end