name "openstack-single-controller"
description "Nova Controller (non-HA)"
run_list(
  "role[openstack-base]",
  "role[openstack-mysql-master]",
  "role[rabbitmq-server]",
  "role[keystone]",
  "role[glance]",
  "role[nova-setup]",
  "role[nova-scheduler]",
  "role[nova-api-ec2]",
  "role[nova-api-os-compute]",
  "role[nova-volume]",
  "role[nova-vncproxy]",
  "role[horizon-server]"
)

