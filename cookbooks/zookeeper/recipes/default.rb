
include_recipe "java"


# setup zookeeper group
group "zookeeper" do
end

# setup zookeeper user
user "zookeeper" do
  comment "Zookeeper user"
  gid "zookeeper"
  home "/home/zookeeper"
  shell "/bin/bash"
  supports :manage_home => true
end

# setup ssh
remote_directory "/home/zookeeper/.ssh" do
  source "ssh"
  owner "zookeeper"
  group "zookeeper"
  files_owner "zookeeper"
  files_group "zookeeper"
  files_mode "0600"
  mode "0700"
end

# create the install dir
directory "#{node[:zookeeper][:install_stage_dir]}" do
  owner "zookeeper"
  group "zookeeper"
  mode "0744"
end

# download zookeeper
remote_file "#{node[:zookeeper][:install_stage_dir]}/zookeeper-#{node[:zookeeper][:version]}.tar.gz" do
  source "http://mirror.uoregon.edu/apache/zookeeper/zookeeper-#{node[:zookeeper][:version]}/zookeeper-#{node[:zookeeper][:version]}.tar.gz"
  owner "zookeeper"
  group "zookeeper"
  mode "0744"
  not_if "test -f #{node[:zookeeper][:install_stage_dir]}/hbase-#{node[:zookeeper][:version]}.tar.gz"
end


# extract it
execute "extract-zookeeper" do
  command "tar -zxf zookeeper-#{node[:zookeeper][:version]}.tar.gz"
  creates "hbase-#{node[:zookeeper][:version]}"
  cwd "#{node[:zookeeper][:install_stage_dir]}"
  user "zookeeper"
  group "zookeeper"
end


link "/usr/local/zookeeper" do
  to "#{node[:zookeeper][:install_stage_dir]}/hbase-#{node[:zookeeper][:version]}"
end



