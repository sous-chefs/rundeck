Description
===========

Configures /etc/resolv.conf, unless the nameservers attribute is
empty.

Attributes
==========

See `attributes/default.rb` for default values.

* `node['resolver']['search']` - the search domain to use
* `node['resolver']['nameservers']` - Required, an array of nameserver
  IP address strings; the default is an empty array, and the default
  recipe will not change resolv.conf if this is not set. See
  __Usage__.
* `node['resolver']['options']` - a hash of resolv.conf options. See
  __Usage__ for examples.

Usage
=====

Set the resolver attributes in a role, for example from my base.rb:

    "resolver" => {
      "nameservers" => ["10.13.37.120", "10.13.37.40"],
      "search" => "int.example.org",
      "options" => {
        "timeout" => 2, "rotate" => nil
      }
    }

The resulting /etc/resolv.conf will look like:

    domain int.example.org
    search int.example.org
    nameserver 10.13.37.120
    nameserver 10.13.37.40
    options timeout:2 rotate

License and Author
==================

Author:: Joshua Timberman (<joshua@opscode.com>)

Copyright 2009-2012, Opscode, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
