#Make sure that this recipe only runs on ubuntu systems
if platform?("ubuntu")

#Base recipes necessary for a functioning system
include_recipe "ubuntu"
include_recipe "apt"
#include_recipe "ad-likewise"
#include_recipe "sudo"
include_recipe "openssh"
include_recipe "ntp"

#Use experience recipes
include_recipe "vim"
include_recipe "man"


# Install useful tools
%w{ lsof mtr strace iotop }.each do |pkg|
  package pkg
end


end
