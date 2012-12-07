maintainer       "Opscode, Inc."
maintainer_email "matt@opscode.com"
license          "Apache 2.0"
description      "The OpenStack Dashboard service Horizon."
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "1.0"

%w{ ubuntu }.each do |os|
  supports os
end

%w{ apache2 database mysql osops-utils }.each do |dep|
  depends dep
end
