#Make sure that this recipe only runs on CentOS/RHEL systems
if platform?("redhat", "centos")

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
