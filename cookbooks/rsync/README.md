Description
===========
Rsync cookbook with rsyncd LWRP

More info on ryncd options can be found in the [Docs][1] 

Requirements
============
Tested on CentOS 6, Ubuntu 12.04. 

Attributes
==========
#### `node['rsyncd']['service']`  *(String)  default: "rsync"* 

The name of the init service 

#### `node['rsyncd']['config']`  *(Hash)  default: "/etc/rsyncd.conf"* 

Path to the rsyncd config file. This is the default, but the serve resource can write config files to arbitrary paths independant of this.

#### `node['rsyncd']['nice']`  *(String)  default: ""*  __Debian/ubuntu only__

#### `node['rsyncd']['ionice']`  *(String)  default: ""*  __Debian/ubuntu only__


#### `node['rsyncd']['globals']`  *(Hash)  default: {}* 

This is where you can store key-value pairs that coincide with rsyncd globals.
As of this writing these are the rsyncd globals per the [Rsyncd docs][1]

* __motd file:__ This parameter allows you to specify a "message of the day" to display to clients on each connect. This usually contains site information and any legal notices. The default is no motd file.
* __pid file:__ This parameter tells the rsync daemon to write its process ID to that file. If the file already exists, the rsync daemon will abort rather than overwrite the file.
* __port:__ You can override the default port the daemon will listen on by specifying this value (defaults to 873). This is ignored if the daemon is being run by inetd, and is superseded by the --port command-line option.
* __address:__ You can override the default IP address the daemon will listen on by specifying this value. This is ignored if the daemon is being run by inetd, and is superseded by the --address command-line option.
* __socket options:__ This parameter can provide endless fun for people who like to tune their systems to the utmost degree. You can set all sorts of socket options which may make transfers faster (or slower!). Read the man page for the setsockopt() system call for details on some of the options you may be able to set. By default no special socket options are set. These settings can also be specified via the --sockopts command-line option.

Refer to the documentation for rsyncd for more info.

Recipes
=======
default
-------
This recipe simply installs the rsync package, nothing more. 

server
------
This recipe sets up the rsyncd service (on centos) and a stub service that is used by the `rsync_serve` LWRP. 

Resources/Providers
===================
serve
-----
This LWRP implements a rsync server module. The folowing params are chef-only, the rest implement the feature as described in the [rsyncd docs][1]
### Parameters
##### Required:
* `path` - Path which this module should server 

##### Optional:
Unless specified these paramaters use the rsyncd default values as refed in the [Rsyncd docs][1]. Params are *Strings* unless specified otherwise. 

* `name` - The name of this module that will be refrenced by rsync://foo/NAME. Defaults to the resource name.
* `config_path` - Path to write the rsyncd config Defaults to `node['rsyncd']['config']
* `comment` - Comment when rsync gets the list of modules from the server.
* `read_only` - *Boolean* - Serve this as a read-only module.
* `write_only`- *Boolean* - Serve this as a write-only module.
* `list` - *Boolean* - Add this module the the rsync modules list 
* `uid` - *String* - This parameter specifies the user name or user ID that file transfers to and from that module should take place as when the daemon was run as root.
* `gid` - *String* - This parameter specifies the group name or group ID that file transfers to and from that module should take place as when the daemon was run as root. 
* `auth_users` - This parameter specifies a comma and space-separated list of usernames that will be allowed to connect to this module. [more info][1]
* `secrets_file` - This parameter specifies the name of a file that contains the username:password pairs used for authenticating this module. [more info][1]
* `hosts_allow` - This parameter allows you to specify a list of patterns that are matched against a connecting clients hostname and IP address. If none of the patterns match then the connection is rejected. [more info][1]
* `hosts_deny` - This parameter allows you to specify a list of patterns that are matched against a connecting clients hostname and IP address. If the pattern matches then the connection is rejected. [more info][1]
* `max_connections` - *Fixnum* - *Default: `0` -  The maximum number of simultaneous connections you will allow. 
* `munge_symlinks` - *Boolean* - *Default: `true` - This parameter tells rsync to modify all incoming symlinks in a way that makes them unusable but recoverable. [more info][1]
* `use_chroot` - *Boolean* - the rsync daemon will chroot to the "path" before starting the file transfer with the client.
* `nemeric_ids` - *Boolean* - *Default: `true` - Enabling this parameter disables the mapping of users and groups by name for the current daemon module.
* `fake_super` - *Boolean* - This allows the full attributes of a file to be stored without having to have the daemon actually running as root.
* `exclude_from` - This parameter specifies the name of a file on the daemon that contains daemon exclude patterns. [more info][1]
* `exclude` - This parameter specifies the name of a file on the daemon that contains daemon exclude patterns. [more info][1]
* `include_from` - Analogue of `exclude_from`
* `include` - Analogue of `exclude`
* `strict_modes` - *Boolean* - If true, then the secrets file must not be readable by any user ID other than the one that the rsync daemon is running under.
* `log_file` - Path where you should store this modules log file. 
* `log_format` - The format is a text string containing embedded single-character escape sequences prefixed with a percent (%) character. An optional numeric field width may also be specified between the percent and the escape letter (e.g. "%-50n %8l %07p"). [more info][1]
* `transfer_logging` - This parameter enables per-file logging of downloads and uploads in a format somewhat similar to that used by ftp daemons. The daemon always logs the transfer at the end, so if a transfer is aborted, no mention will be made in the log file.
* `timeout` - *Fixnum* - Default: `600` - Using this parameter you can ensure that rsync won't wait on a dead client forever. The timeout is specified in seconds. A value of zero means no timeout.
* `dont_compress` - This parameter allows you to select filenames based on wildcard patterns that should not be compressed when pulling files from the daemon
* `lock_file` - This parameter specifies the file to use to support the "max connections" parameter. The rsync daemon uses record locking on this file to ensure that the max connections limit is not exceeded for the modules sharing the lock file. The default is /var/run/rsyncd.lock


Usage
=====
After loading the rsync cookbook you have acces to the `rsync_serve` resource for serving up a generic rsyncd module wiht many options. You should include `rsync::server` before trying to use the LWRP as it will setup the basic rsync service for your platform. 

Examples
--------
More complex example in examples/recipes, but the simplest form of serving up a directory:

     rsync_serve "temp_module" do
       path "/tmp/foo"
     end


License and Author
==================

Author:: Jesse Nelson <spheromak@gmail.com>

Copyright:: 2012, Opscode, Inc

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.


[1]: http://www.samba.org/ftp/rsync/rsyncd.conf.html "Rsyncd Docs"
