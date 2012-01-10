#Make sure that this recipe only runs on ubuntu systems
if platform?("ubuntu")

include_recipe "ubuntu"
include_recipe "apt"
include_recipe "vim"

# Install useful tools
%w{ manpages man-db lsof mtr strace iotop }.each do |pkg|
  package pkg
end


end
