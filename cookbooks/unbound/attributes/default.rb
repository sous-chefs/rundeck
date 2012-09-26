default['unbound']['interface'] = [ node['ipaddress'] ]
default['unbound']['outgoing_interface'] = nil
default['unbound']['port'] = 53
default['unbound']['num_threads'] = 1
default['unbound']['enable_ipv4'] = true
default['unbound']['enable_ipv6'] = false
default['unbound']['enable_tcp'] = true
default['unbound']['enable_udp'] = true
default['unbound']['access_control'] = { "127.0.0.1/8" => "allow", "0.0.0.0/0" => "refuse" }
default['unbound']['logfile'] =  ""
default['unbound']['use_syslog'] = "yes"

default['unbound']['remote_control']['enable'] = "no"
default['unbound']['remote_control']['interface'] = "127.0.0.1"
default['unbound']['remote_control']['port'] = "953"

default['unbound']['stats']['interval'] = 0
default['unbound']['stats']['cumulative'] = "no"
default['unbound']['stats']['extended'] = "no"

#default['unbound']['dnssec'] - disabled by default, future todo

case node['platform']
when "freebsd"
  default['unbound']['directory'] = "/usr/local//etc/unbound"
  default['unbound']['pidfile'] = "/usr/local/etc/unbound/unbound.pid"
  default['unbound']['bindir'] = "/usr/local/sbin"
else
  default['unbound']['directory'] = "/etc/unbound"
  default['unbound']['pidfile'] = "/var/run/unbound.pid"
  default['unbound']['bindir'] = "/usr/sbin"
end
