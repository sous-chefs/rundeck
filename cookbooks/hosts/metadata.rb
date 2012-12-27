name             "hosts"
maintainer       "Tim Smith - Webtrends Inc."
maintainer_email "tim.smith@webtrends.com"
license          "All rights reserved"
description      "Configures the /etc/hosts file"
version          "1.0.1"

%w{ centos redhat amazon scientific oracle }.each do |os|
  supports os
end