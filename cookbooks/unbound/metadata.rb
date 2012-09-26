maintainer       "Joshua Timberman"
maintainer_email "cookbooks@housepub.org"
license          "Apache 2.0"
description      "Manages unbound DNS resolver"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.1.1"

recipe "unbound::default", "Installs unbound and sets up configuration files"
recipe "unbound::chroot", "Sets up the chroot environment if chroot attribute is enabled"
recipe "unbound::remote_control", "Sets up remote control certificates"

attribute 'unbound/directory',
  :display_name => 'Unbound directory',
  :description => 'Configuration directory, depends on platform',
  :calculated => true

attribute 'unbound/pidfile',
  :display_name => 'Unbound PID file',
  :description => 'PID file for the daemon process, depends on platform',
  :calculated => true

attribute 'unbound/bindir',
  :display_name => 'Unbound binary location',
  :description => 'Location for the unbound binaries, depends on platform',
  :calculated => true

attribute 'unbound/interface',
  :display_name => 'Listen interfaces',
  :description => 'Array of IP address interfaces to listen on, default is the nodes ipaddress',
  :type => "array",
  :calculated => true

attribute 'unbound/outgoing_interface',
  :display_name => 'Outgoing interfaces',
  :description => 'Array of IP address interfaces to send outgoing queries to',
  :type => "array",
  :default => []

attribute 'unbound/port',
  :display_name => 'Answer port',
  :description => 'Port to answer queries',
  :default => '53'

attribute 'unbound/num_threads',
  :display_name => 'Number of threads',
  :description => 'Number of threads to create, 1 disables threading (default)',
  :default => '1'

attribute 'unbound/enable_ipv4',
  :display_name => 'Enable IPV4',
  :description => 'Whether to enable IPV4',
  :default => 'true'

attribute 'unbound/enable_tcp',
  :display_name => 'Enable TCP',
  :description => 'Whether to enable TCP',
  :default => 'true'

attribute 'unbound/enable_udp',
  :display_name => 'Enable UDP',
  :description => 'Whether to enable UDP',
  :default => 'true'

attribute 'unbound/access_control',
  :display_name => 'Client access controls',
  :description => 'Client access controls, key is the netblock size and value is the action',
  :type => "hash",
  :default => { "127.0.0.1/8" => "allow", "0.0.0.0/0" => "refuse" }

attribute 'unbound/logfile',
  :display_name => 'Log file',
  :description => 'Log file to write to, default "" writes to stderr',
  :default => ''

attribute 'unbound/use_syslog',
  :display_name => 'Log to Syslog',
  :description => 'Whether to log messages to syslog, as daemon, with identity unbound',
  :default => 'yes'

attribute 'unbound/chroot',
  :display_name => 'Chroot directory',
  :description => 'Specifies the directory to chroot, default "" sets no chroot',
  :default => ''

attribute 'unbound/remote_control/enable',
  :display_name => 'Remote control enable',
  :description => 'Whether to enable remote control',
  :default => nil

attribute 'unbound/remote_control/interface',
  :display_name => 'Remote control interface',
  :description => 'Interface for remote control',
  :default => '127.0.0.1'

attribute 'unbound/remote_control/server_key',
  :display_name => 'Remote control server key',
  :description => 'Server key file for remote control, in the configuration directory',
  :calculated => true

attribute 'unbound/remote_control/server_cert',
  :display_name => 'Remote control server certificate',
  :description => 'Server certificate file for remote control, in the configuration directory',
  :calculated => true

attribute 'unbound/remote_control/control_key',
  :display_name => 'Remote control control key',
  :description => 'Control key file for remote control, in the configuration directory',
  :calculated => true

attribute 'unbound/remote_control/control_cert',
  :display_name => 'Remote control control certificate',
  :description => 'Control certificate file for remote control, in the configuration directory',
  :calculated => true

attribute 'unbound/dnssec',
  :display_name => 'DNSSEC settings',
  :description => 'Not yet implemented'

attribute 'unbound/stats/internal',
  :display_name => 'Unbound statistics-interval',
  :description => 'Corresponds to statistics-interval config setting',
  :default => '0'

attribute 'unbound/stats/cumulative',
  :display_name => 'Unbound statistics-cumulative',
  :description => 'Corresponds to statistics-cumulative config setting',
  :default => 'no'

attribute 'unbound/stats/extended',
  :display_name => 'Unbound extended-statistics',
  :description => 'Corresponds to extended-statistics config setting',
  :default => 'no'
