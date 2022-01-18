name             'rundeck'
maintainer       'Sous Chefs'
maintainer_email 'help@sous-chefs.org'
license          'Apache-2.0'
description      'Installs and configures Rundeck 2.x'
version          '7.2.0'
depends          'java', '>= 8.0.0'
depends          'apache2', '~> 7.0.0'

%w(ubuntu centos fedora redhat scientific oracle).each do |os|
  supports os
end

source_url 'https://github.com/sous-chefs/rundeck'
issues_url 'https://github.com/sous-chefs/rundeck/issues'
chef_version '>= 15.5'
