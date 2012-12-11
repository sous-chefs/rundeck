name "openstack-mysql-master"
description "MySQL Server (non-ha)"
run_list(
  "role[openstack-base]",
  "recipe[mysql-openstack::server]"
)
