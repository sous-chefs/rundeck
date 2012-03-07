actions :install
attribute :server_name, :kind_of => String
attribute :server_alias, :kind_of => Array, :default => []
attribute :socket, :kind_of => String
attribute :timeout, :kind_of => Integer, :default => 180
attribute :access_log, :kind_of => String
attribute :error_log, :kind_of => String
attribute :start_service, :kind_of => [TrueClass,FalseClass], :default => true
attribute :ssl, :kind_of => [TrueClass,FalseClass], :default => false
attribute :ssl_cipher_suite, :kind_of => String
attribute :ssl_certificate_file, :kind_of => String
attribute :ssl_certificate_key_file, :kind_of => String


