#!/bin/bash -xv
#
# Preseed firstboot script
#

exec > >(tee /root/firstboot.log) 2>&1

# generate first boot json
runlist=$(cat /var/tmp/runlist)
realrunlist=$(for item in ${runlist//,/ }; do echo -n "\"${item}\","; done | sed 's/,$//')
echo "{ \"run_list\": [ $realrunlist ] }" > /etc/chef/first-boot.json

# set chef environment if running chef 0.10+ and environment is specified
environment=$(cat /var/tmp/environment)
if [[ ! `chef-client --version` =~ 0\.9\.* && -n "$environment" ]] ; then
  chef_environment="-E $environment"
fi

# run chef
/etc/init.d/chef-client stop
chef-client ${chef_environment} -j /etc/chef/first-boot.json
/etc/init.d/chef-client restart

# cleanup
chmod 600 /etc/chef/validation.pem /root/firstboot.log
rm /etc/chef/first-boot.json
rm /var/tmp/runlist /var/tmp/environment
