maintainer       "Eric G. Wolfe"
maintainer_email "wolfe21@marshall.edu"
license          "Apache 2.0"
description      "Installs/Configures snmp on redhat, centos, ubuntu, debian"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
name             "snmp"
depends          "perl"
version          "0.3.1"

recipe "snmp", "Installs and configures snmpd"

%w{ ubuntu debian redhat centos scientific fedora }.each do |os|
  supports os
end

attribute "snmp",
  :display_name => "SNMP",
  :description => "Hash of SNMP attributes",
  :type => "hash"

attribute "snmp/service",
  :display_name => "SNMPD",
  :description => "SNMP Daemon name",
  :calculated => true

attribute "snmp/packages",
  :display_name => "SNMP packages",
  :description => "SNMP packages name",
  :calculated => true

attribute "snmp/cookbook_files",
  :display_name => "SNMP cookbook files",
  :description => "SNMP cookbook files for Debian/Ubuntu",
  :calculated => true

attribute "snmp/community",
  :display_name => "Community String",
  :description => "Community String, defaults to public",
  :default => "public",
  :required => "recommended"

attribute "snmp/syslocationVirtual",
  :display_name => "syslocation Virtual",
  :description => "syslocation for Virtual Machines",
  :default => "Virtual Server",
  :required => "optional"

attribute "snmp/syslocationPhysical",
  :display_name => "syslocation Physical",
  :description => "syslocation for Physical Machines",
  :default => "Server Room",
  :required => "optional"

attribute "snmp/syscontact",
  :display_name => "syscontact",
  :description => "System Contact",
  :default => "Root <root@localhost>",
  :required => "optional"

attribute "snmp/trapcommunity",
  :display_name => "trapcommunity",
  :description => "SNMP Trap Community",
  :default => "public",
  :required => "optional"

attribute "snmp/trapsinks",
  :display_name => "trapsinks",
  :description => "Trapsink hostnames for NMS systems",
  :type => "array"

attribute "snmp/full_systemview",
  :display_name => "full_systemview",
  :description => "Enable full systemview for NMS systems",
  :default => "false",
  :required => "recommended"

attribute "snmp/install_utils",
  :display_name => "install_utils",
  :description => "Enable installation of SNMP utilities, like snmpwalk",
  :default => "false",
  :required => "optional"

attribute "snmp/is_dnsserver",
  :display_name => "is_dnsserver",
  :description => "Enable snmp_rndc_stats SNMP Extend monitor",
  :default => "false",
  :required => "optional"
