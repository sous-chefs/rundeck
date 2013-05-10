wt_openldap Cookbook
====================
Installs and configures Openldap and optionally import a backup LDIF file.


Requirements
------------
#### packages
- `ldap-utils` - client tools
- `slapd` -  openldap server

Attributes
----------

#### wt_openldap::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
  </tr>
  <tr>
    <td><tt>['wt_openldap']['version']</tt></td>
    <td>String</td>
    <td>Version of deb package to install.</td>
  </tr>
  <tr>
    <td><tt>['wt_openldap']['common_name']</tt></td>
    <td>String</td>
    <td>SSL Certificate Common Name (CN)</td>
  </tr>
  <tr>
    <td><tt>['wt_openldap']['num_backups_retained']</tt></td>
    <td>Integer</td>
    <td>Number of days to retain backup file</td>
  </tr>
  <tr>
    <td><tt>['wt_openldap']['backup_nfs_mount']</tt></td>
    <td>String</td>
    <td>Exported NFS Mount device for writing backups</td>
  </tr>
  <tr>
    <td><tt>['wt_openldap']['mount_path']</tt></td>
    <td>String</td>
    <td>Local NFS mount point</td>
  </tr>
</table>

See attributes file for defaults.

Usage
-----
#### wt_openldap::default

Just include `wt_openldap` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[wt_openldap]"
  ]
}
```
#### Restore backup

In a lab environment, you can optionally restore a backup by providing the source in the environment.

Example:

OPENLDAP_RESTORE_SOURCE=http://repo.staging.dmz/repo/artifact/openldap/backup.ldif chef-client

License and Authors
-------------------
Authors: David Dvorak (<david.dvorak@webtrends.com>)
