maintainer       "BBY Solutions, Inc."
maintainer_email "andrew.painter@bestbuy.com"
license          "Apache 2.0"
description      "Installs/Configures a Splunk Server, Forwarders, and Apps"
version          "0.0.9"
%w{redhat centos fedora debian ubuntu}.each do |os|
  supports os
end
