default["horizon"]["db"]["username"] = "dash"
default["horizon"]["db"]["password"] = "dash"
default["horizon"]["db"]["name"] = "dash"

default["horizon"]["use_ssl"] = true
default["horizon"]["ssl"]["cert"] = "horizon.pem"
default["horizon"]["ssl"]["key"] = "horizon.key"

case node["platform"]
when "fedora", "centos", "redhat", "amazon", "scientific"
  default["horizon"]["ssl"]["dir"] = "/etc/pki/tls"
  default["horizon"]["local_settings_path"] = "/etc/openstack-dashboard/local_settings"
  # TODO(shep) - Fedora does not generate self signed certs by default
when "ubuntu", "debian"
  default["horizon"]["ssl"]["dir"] = "/etc/ssl"
  default["horizon"]["local_settings_path"] = "/etc/openstack-dashboard/local_settings.py"
end

default["horizon"]["dash_path"] = "/usr/share/openstack-dashboard/openstack_dashboard"
default["horizon"]["wsgi_path"] = node["horizon"]["dash_path"] + "/wsgi"
