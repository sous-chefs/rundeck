maintainer        "Rackspace US, Inc."
license           "Apache 2.0"
description       "Makes the rabbitmq cookbook behave correctly with OpenStack"
version           "1.0.4"

%w{ ubuntu fedora }.each do |os|
  supports os
end

depends "rabbitmq", "> 1.6.2"
depends "osops-utils"
