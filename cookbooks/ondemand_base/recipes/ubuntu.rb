#Make sure that this recipe only runs on ubuntu systems
if platform?("ubuntu")

#Base recipes necessary for a functioning system
include_recipe "ubuntu"
include_recipe "users::sysadmins"
#include_recipe "sudo"
include_recipe "apt"
#include_recipe "ad-likewise"
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


end
