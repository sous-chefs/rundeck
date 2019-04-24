repository
===

Use the **repository** resource to install a package repository that contains the Rundeck packages.

Syntax
------

The full syntax for all of the properties available to the **repository** resource is:

****
```ruby
repository 'rundeck repo' do
  package_uri                   String # URI to the package repository.
  gpgkey                        String # GPG Key used to sign packages.
  gpgcheck                      [true, false] # Whether to perform GPG verification on packages.
end
```

Actions
-------

`:install`

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Install the package repository. This is the only, and default, action.

Examples
--------

**Install the default Rundeck public repository**

```ruby
repository 'Rundeck Public' do
end
```