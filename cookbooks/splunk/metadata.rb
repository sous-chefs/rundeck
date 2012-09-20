maintainer       "Best Buy"
maintainer_email "bryan.brandau@bestbuy.com"
license          "Apache 2.0"
description      "Installs/Configures Splunk Server, Forwarder, Deployment Monitor and *nix App"
version          "0.0.4"
%w{redhat centos fedora debian ubuntu}.each do |os|
  supports os
end
