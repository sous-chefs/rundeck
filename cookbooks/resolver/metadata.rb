maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Configures /etc/resolv.conf via attributes"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "1.0.2"

recipe "resolver", "Configures /etc/resolv.conf via attributes"

%w{ ubuntu debian fedora centos redhat freebsd openbsd macosx }.each do |os|
  supports os
end

attribute "resolver",
  :display_name => "Resolver",
  :description => "Hash of Resolver attributes",
  :type => "hash"

attribute "resolver/search",
  :display_name => "Resolver Search",
  :description => "Default domain to search",
  :default => "domain"

attribute "resolver/nameservers",
  :display_name => "Resolver Nameservers",
  :description => "Default nameservers",
  :type => "array",
  :default => []

attribute "resolver/options",
  :display_name => "Resolver Options",
  :description => "Default resolver options",
  :type => "hash",
  :default => {}
