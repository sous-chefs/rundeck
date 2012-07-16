maintainer       "Webtrends Inc"
maintainer_email "hostedops@webtrends.com"
license          "Apache 2.0"
description      "Installs/Configures various HP tools"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.3.0"

%w{ centos redhat fedora amazon scientific }.each do |os|
  supports os
end
