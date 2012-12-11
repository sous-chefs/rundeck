default['rabbitmq']['services']['queue']['scheme'] = "tcp"          # node_attribute
default['rabbitmq']['services']['queue']['port'] = "5672"           # node_attribute
default['rabbitmq']['services']['queue']['network'] = "nova"        # node_attribute

case platform
when "fedora", "redhat", "centos", "amazon", "scientific"
  default["rabbitmq"]["platform"] = {                               # node_attribute
    "rabbitmq_service" => "rabbitmq-server",
    "rabbitmq_service_regex" => "/etc/rabbitmq/rabbitmq",
    "package_overrides" => ""
  }
when "ubuntu"
  default["rabbitmq"]["platform"] = {                               # node_attribute
    "rabbitmq_service" => "rabbitmq-server",
    "rabbitmq_service_regex" => "/etc/rabbitmq/rabbitmq",
    "package_overrides" => "-o Dpkg::Options::='--force-confold' -o Dpkg::Options::='--force-confdef'"
  }
end
