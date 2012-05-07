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

/etc/init.d/chef-client stop

# run chef for the first time and set environment
if [[ `expr length "$environment"` -eq 1 ]]; then
  echo "{ \"run_list\": [ \"recipe[wt_base::set_environment]\" ] }" > /etc/chef/set-environment.json
  CHEF_ENVIRONMENT=$environment chef-client -j /etc/chef/set-environment.json
  rm /etc/chef/set-environment.json
else
  chef-client ${chef_environment} -j /etc/chef/first-boot.json
fi

# run chef for the first time after setting environment
chef-client ${chef_environment} -j /etc/chef/first-boot.json

/etc/init.d/chef-client restart

# cleanup
chmod 600 /etc/chef/validation.pem /root/firstboot.log
rm /etc/chef/first-boot.json
rm /var/tmp/runlist /var/tmp/environment
