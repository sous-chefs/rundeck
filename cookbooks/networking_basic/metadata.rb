maintainer       "fredz"
maintainer_email "fred@frederico-araujo.com"
license          "Apache 2.0"
description      "Install Basic Netwoking Tools ans Utilities on Debian5 and Ubuntu10"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.0.5"

%w{ ubuntu debian centos redhat amazon scientific fedora}.each do |os|
  supports os
end