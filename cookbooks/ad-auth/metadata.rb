maintainer       "Peter Crossley, Tim Smith"
maintainer_email "peterc@xley.com, tim.smith@webtrends.com"
license          "Apache 2.0"
description      "Configures Active Directory authentication support using Likewise Open 6"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "1.0.7"
depends          "sudo"
%w{redhat centos fedora ubuntu debian amazon scientific}.each do |os|
  supports os
end
