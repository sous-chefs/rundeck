name             'rundeck'
maintainer       'Sous Chefs'
maintainer_email 'help@sous-chefs.org'
license          'Apache-2.0'
description      'Installs and configures Rundeck 2.x'
version          '8.0.5'
depends          'java'
depends          'apache2'

%w(ubuntu centos fedora redhat scientific oracle).each do |os|
  supports os
end

source_url 'https://github.com/sous-chefs/rundeck'
issues_url 'https://github.com/sous-chefs/rundeck/issues'
chef_version '>= 15.5'
