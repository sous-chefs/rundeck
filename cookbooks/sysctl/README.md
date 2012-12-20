Description
===========

Set sysctl values from Chef!

Attributes
==========

* `node['sysctl']` - A namespace for sysctl settings.

Usage
=====

There are two ways of setting sysctl values:

1. Set chef attributes in the **sysctl** namespace. e.g.:

        node.set['sysctl']['set swappiness'] = { 'vm.swappiness' => '20' }
2. Set values in a `cookbook_file` Resource.
3. With Ressource/Provider.

Resource/Provider
=================

This Cookbook includes two LWRPs:

1. **sysctl**
2. **sysctl_multi**

sysctl
------

## Actions

- **:save** - Save and set a sysctl value (default).
- **:set** - Set a sysctl value.
- **:remove** - Remove a (previous set) sysctl.

## Attribute Parameters

- **variable** - Variable to manage. e.g. `net.ipv4.ip_forward`, `vm.swappiness`.
- **value** - Value to affect to variable. e.g. `1`, `0`.
- **path** - Path to a specific file.

### Examples

###ruby

    # Set 'vm.swappiness' to '60'. Will create /etc/sysctl.d/40-vm.wappiness.conf
    sysctl 'vm.swappiness' do
        value '40'
    end

####the same. will create `/etc/sysctl.d/40-vm_swappiness_to_60.conf`

    sysctl 'vm swappiness to 60' do
      variable 'vm.swappiness'
      value '60'
    end

####Remove /etc/sysctl.d/40-ip_config.conf
    sysctl 'ip config' do
      action :remove
    end

#### Set swappiness but don't save it.
    sysctl 'vm.swappiness' do
      action :set
      value '40'
    end


sysctl_multi
------------

### Actions

- **:save** - Save and set a sysctl value (default).
- **:set** - set a sysctl value.
- **:remove** - remove a (previous set) sysctl.

### Attribute Parameters

- **instructions** - Hash with instruction. e.g. `{variable => value, variable2 => value2}`.
  Override use of 'variable' and 'value'.
- **path** - Path to a specific file.

### Examples

####ruby
### set multi variables. will create /etc/sysctl.d/69-ip_config.conf
    sysctl_multi 'ip config' do
      instructions {
        'net.ipv4.ip_forward' => '1',
        'net.ipv6.conf.all.forwarding' => '1',
        'net.ipv4.tcp_syncookies' => '1'}
    end

