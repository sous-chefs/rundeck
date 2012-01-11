#Make sure that this recipe only runs on CentOS/RHEL systems
if platform?("redhat", "centos")

include_recipe "vim"

end
