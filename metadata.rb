name             'rundeck'
maintainer       'Webtrends, Inc.'
maintainer_email 'Peter Crossley <peter.crossley@webtrends.com>'
license          'All rights reserved'
description      'Installs and configures Rundeck 2.x'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '3.2.1'
depends          'runit'
depends          'sudo'
depends          'java'
depends          'apache2'
depends          'java-libraries'

%w(debian ubuntu centos suse fedora redhat freebsd windows scientific oracle amazon mac_os_x).each do |os|
  supports os
end

recipe 'rundeck::apache', 'Use this recipe to install the rundeck apache webserver'
recipe 'rundeck::server', 'Use this recipe to install the rundeck server on a node'
recipe 'rundeck::server_install', 'Use this recipe to install the rundeck server on a node, without the dependencies or webserver'
recipe 'rundeck::server_dependencies', 'Use this recipe to install the dependencies for the rundeck server install'
recipe 'rundeck::chef-rundeck', 'Use this recipe to install the chef rundeck integration component, by default it is recommened to install on the chef server.'
recipe 'rundeck::default', 'Use this recipe to manage the node as a target in rundeck, this recipe is included in rundeck::server'
recipe 'rundeck::node_unix', 'Unix\Linux platform configuration, do not use on a node, the default recipe uses this implmentation'
recipe 'rundeck::node_windows', 'Windows platform configuration, do not use on a node, the default recipe uses this implmentation'

source_url 'https://github.com/webtrends/rundeck' if respond_to?(:source_url)
issues_url 'https://github.com/webtrends/rundeck/issues' if respond_to?(:issues_url)
