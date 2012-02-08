#Make sure that this recipe only runs on ubuntu systems
if platform?("centos")

#Base recipes necessary for a functioning system
include_recipe "selinux::permissive"
include_recipe "sudo"
include_recipe "ad-likewise"
include_recipe "openssh"
include_recipe "ntp"

#User experience and tools recipes
include_recipe "vim"
include_recipe "man"
include_recipe "networking_basic"

# Install useful tools
%w{ mtr strace iotop }.each do |pkg|
  package pkg
end

# Disable iptables firewall
service "iptables" do
  action :stop
  action :disable
end

# Used for password string generation
package "ruby-shadow"

#Pull authorization data from the authorization data bag
auth_config = data_bag_item('authorization', node.chef_environment)

# set root password from authorization databag
#user "root" do
#  password auth_config['root_password']
#end

# add non-root user from authorization databag
if auth_config['alternate_user']
  user auth_config['alternate_user'] do
    password auth_config['alternate_pass']
    if auth_config['alternate_uid']
      uid auth_config['alternate_uid']
    end
  not_if "grep #{auth_config['alternate_user']} /etc/passwd"
  end
end

end
