maintainer       "Webtrends Inc"
maintainer_email "josh.behrends@webtrends.com"
license          "All rights reserved"
description      "Installs/Configures gdash"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"

%w{ debian ubuntu }.each do |os|
  supports os
end

depends "apache2"
