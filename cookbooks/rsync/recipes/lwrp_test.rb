
include_recipe "rsync::server"

# more complex with allow/deny logging etc etc.
rsync_serve "test" do 
  path "/tmp"
  comment "lwrp test module"
  read_only true
  use_chroot true
  list true
  uid "nobody"
  gid "nobody"
  hosts_allow "127.0.0.1, 10.4.1.0/24, 192.168.4.0/24"
  hosts_deny  "0.0.0.0/0"
  max_connections 10
  transfer_logging true
  log_file "/tmp/lwrp_test"
end


