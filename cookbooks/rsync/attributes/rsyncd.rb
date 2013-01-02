
case platform
when "centos", "redhat", "amazon"
  default['rsyncd']['service'] = "rsyncd"
when "debian", "ubuntu"
  default['rsyncd']['service'] = "rsync"
else
  Chef::Log.warn "No explicit service name for this platform set, using rsyncd"
  default['rsyncd']['service'] = "rsyncd"
end


default['rsyncd']['config']  = "/etc/rsyncd.conf"
default['rsyncd']['globals'] = Hash.new

# only used on debian platforms
default['rsyncd']['nice'] = ""
default['rsyncd']['ionice'] = ""
