name             'rundeck'
maintainer       'Sous Chefs'
maintainer_email 'help@sous-chefs.org'
license          'Apache-2.0'
description      'Installs and configures Rundeck 2.x'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '5.0.0'
# depends          'runit'
# depends          'sudo'
depends          'java', '~> 3.1.0'
depends          'apache2'
# depends          'simple_passenger'
# depends          'build-essential'

%w(debian ubuntu centos suse fedora redhat freebsd windows scientific oracle amazon mac_os_x).each do |os|
  supports os
end


source_url "https://github.com/sous-chefs/#{name}"
issues_url "https://github.com/sous-chefs/#{name}/issues"
chef_version '>= 12.1' if respond_to?(:chef_version)
