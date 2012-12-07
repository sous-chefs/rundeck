name "openstack-single-compute"
description "Nova compute (with non-HA Controller)"
run_list(
  "role[openstack-base]",
  "recipe[nova::compute]"
)

