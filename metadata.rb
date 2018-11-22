name             'rundeck'
maintainer       'Sous Chefs'
maintainer_email 'help@sous-chefs.org'
license          'Apache-2.0'
description      'Installs and configures Rundeck 2.x'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '4.2.0'
depends          'java'
depends          'apache2'

%w(ubuntu centos fedora redhat).each do |os|
  supports os
end

source_url "https://github.com/sous-chefs/#{name}"
issues_url "https://github.com/sous-chefs/#{name}/issues"
chef_version '>= 12.1' if respond_to?(:chef_version)
