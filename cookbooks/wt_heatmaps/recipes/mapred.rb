
package "php-cli"

zk_quorum = search(:node, "role:zookeeper AND chef_environment:#{node.chef_environment}")

template "/etc/zookeeper" do
  source "zookeeper"
  owner "hadoop"
  group "hadoop"
  mode 0755
  variables(
    :zk_quorum => zk_quorum
  )
end

template "/etc/config_distrib" do
  source "config_distrib"
  owner "hadoop"
  group "hadoop"
  mode 0755
end

template "/etc/heatmap_reducers" do
  source "heatmap_reducers"
  owner "hadoop"
  group "hadoop"
  mode 0755
end

remote_directory "/usr/local/mapred" do
  source "mapred"
  owner "hadoop"
  group "hadoop"
  files_owner "hadoop"
  files_group "hadoop"
  files_mode "0744"
  mode "0744"
end

