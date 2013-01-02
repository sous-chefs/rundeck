# SNMP [![Build Status](https://secure.travis-ci.org/atomic-penguin/cookbook-snmp.png?branch=master)](http://travis-ci.org/atomic-penguin/cookbook-snmp)

## DESCRIPTION

Installs and configures snmpd.

The SNMP multiplex (smuxpeer) line will be set for Dell OpenManage, if Dell
manufactured hardware is detected by Ohai.

## REQUIREMENTS

This cookbook provides an SNMP Extend example to collect DNS RNDC statistics.
The SNMP Extend script is written in Perl and depends on the CPAN module "version",
and Getopt::Declare.

There is a loose dependency recommending the "perl" cookbook.
If you have no need for the SNMP Extend example included, you may remove the
"depends perl" line from metadata.rb. Then run 'knife cookbook metadata snmp'
before uploading to the Chef server.

## RECIPES

* snmp::default
  - Installs and configures SNMP

* snmp::extendbind
  - Example recipe to deploy a Perl based extend script to collect stats
    from a BIND 9 server.

## ATTRIBUTES

Notable overridable attributes are as follows.  It is recommended to override
these following attributes to best suit your own environment.

* snmp[:community]
  - SNMP Community String, default is "public".

* snmp[:trapcommunity]
  - SNMP Community Trap String, default is "public".

* snmp[:trapsinks]
  - Array of trapsink hosts, and optionall Community Trap strings.
    This is an empty array by default.

* snmp[:syscontact]
  - String to set a name, and e-mail address for systems.
    Default is "Root <root@localhost>"

* snmp[:syslocationPhysical]
  - String to set the location for physical systems.
    Default is "Server Room".

* snmp[:syslocationVirtual]
  - String to set the location for Virtual Machines.
    Default is "Virtual Server".

* snmp[:full\_systemview]
  - Boolean to include the full systemview.
    This defaults to "false" as many distributions ship this way to speed up
     snmpwalk.  However, if you're running SNMP Network Management System,
     you'll want to override this as "true" on your systems.

## USAGE

Here is a full example featuring all the overridable attributes.
You can apply these override attributes in a role, or node context.

```
  override_attributes "snmp" => {
    "community" => "secret",
    "full_systemview" => true,
    "trapsinks" => [ "zenoss.example.com", "nagios.example.com" ],
    "syslocationPhysical" => "Server Room",
    "syslocationVirtual" => "Cloud - Virtual Pool",
    "syscontact" => "sysadmin@example.com"
  }
```

## ACKNOWLEDGEMENTS

Thanks to Sami Haahtinen <zanaga> on Freenode/#chef for testing,
and feedback pertinent to the Debian/Ubuntu platforms.

## AUTHOR AND LICENSE

Author:: Eric G. Wolfe (<wolfe21@marshall.edu>)

Copyright 2010-2012

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
