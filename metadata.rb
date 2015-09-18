name             'rundeck'
maintainer       'Webtrends, Inc.'
maintainer_email 'Peter Crossley <peter.crossley@webtrends.com>'
license          'All rights reserved'
description      'Installs and configures Rundeck 2.0'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '2.0.7'
depends          'runit'
depends          'sudo'
depends          'java'
depends          'apache2'
depends          'yum'

%w(debian ubuntu centos suse fedora redhat freebsd windows).each do |os|
  supports os
end

recipe 'rundeck::server', 'Use this recipe to install the rundeck server on a node'
recipe 'rundeck::chef-rundeck', 'Use this recipe to install the chef rundeck integration component, by default it is recommened to install on the chef server.'
recipe 'rundeck::default', 'Use this recipe to manage the node as a target in rundeck, this recipe is included in rundeck::server'
recipe 'rundeck::node_unix', "Unix\Linux platform configuration, do not use on a node, the default recipe uses this implmentation"
recipe 'rundeck::node_windows', 'Windows platform configuration, do not use on a node, the default recipe uses this implmentation'
