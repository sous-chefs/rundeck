name              "nscd"
maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Installs and configures nscd"
version           "0.8.2"
suggests          "openldap"

recipe "nscd", "Installs and configures nscd"

<<<<<<< HEAD
%w{ redhat centos debian ubuntu amazon scientific }.each do |os|
=======
%w{ redhat centos debian ubuntu amazon scientific oracle }.each do |os|
>>>>>>> chef-vendor-nscd
  supports os
end
