#
# Rsync Server Module Resource
#
# Recipe:: rsync
# Resource:: serve
#
#

actions :add, :remove
default_action :add

# man rsyncd.conf for more info on each attribute
attribute :name, :kind_of => String, :name_attribute => true
attribute :config_path, :kind_of => String, :default => "/etc/rsyncd.conf"
attribute :path, :kind_of => String, :required => true
attribute :comment, :kind_of => String
attribute :read_only, :kind_of => [ TrueClass, FalseClass ]
attribute :write_only, :kind_of => [ TrueClass, FalseClass ]
attribute :list, :kind_of => [ TrueClass, FalseClass ]
attribute :uid, :kind_of => String
attribute :gid, :kind_of => String
attribute :auth_users, :kind_of => String
attribute :secrets_file, :kind_of => String
attribute :hosts_allow, :kind_of => String
attribute :hosts_deny, :kind_of => String
attribute :max_connections, :kind_of => Fixnum, :default => 0
attribute :munge_symlinks, :kind_of => [ TrueClass, FalseClass ], :default => true
attribute :use_chroot, :kind_of => [ TrueClass, FalseClass ]
attribute :numeric_ids, :kind_of => [ TrueClass, FalseClass ], :default => true
attribute :fake_super, :kind_of => [ TrueClass, FalseClass ]
attribute :exclude_from, :kind_of => String
attribute :exclude, :kind_of => String
attribute :include_from, :kind_of => String
attribute :include, :kind_of => String
attribute :strict_modes, :kind_of => [ TrueClass, FalseClass ]
attribute :log_file, :kind_of => String
attribute :log_format, :kind_of => String
attribute :transfer_logging, :kind_of =>  [ TrueClass, FalseClass ]
# by default rsync sets no client timeout (lets client choose, but this is a trivial DOS) so we make a 10 minute one
attribute :timeout, :kind_of => Fixnum, :default => 600
attribute :dont_compress, :kind_of  =>  String
attribute :lock_file, :kind_of => String

