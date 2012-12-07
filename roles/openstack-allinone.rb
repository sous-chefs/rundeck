name "openstack-allinone"
description "This will create an all-in-one Openstack cluster"
run_list(
  "role[openstack-single-controller]",
  "role[openstack-single-compute]"
)
