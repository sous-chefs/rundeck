#Make sure that this recipe only runs on ubuntu systems
if platform?("ubuntu")

include_recipe "ubuntu"
include_recipe "apt"

# Ubuntu ships with vim-tiny, which lacks many of the basic features found in the vim package
package "vim"

# Install useful tools
%w{ manpages man-db lsof mtr strace }.each do |pkg|
  package pkg
end


end
