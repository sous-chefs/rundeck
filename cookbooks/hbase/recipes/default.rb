

hadoop_namenode = search(:node, "role:hadoop_namenode AND chef_environment:#{node.chef_environment}")
hadoop_namenode = hadoop_namenode.length == 1 ? hadoop_namenode.first[:fqdn] : "localhost"

hmaster = search(:node, "role:hadoop_namenode AND chef_environment:#{node.chef_environment}")
hmaster = hmaster.length == 1 ? hmaster.first[:fqdn] : "localhost"

regionservers = Array.new
search(:node, "role:hadoop_datanode AND chef_environment:#{node.chef_environment}").each do |n|
  regionservers << n[:fqdn]
end



include_recipe "hadoop"


# download hbase
remote_file "#{node[:hadoop][:install_stage_dir]}/hbase-#{node[:hbase][:version]}.tar.gz" do
  source "http://mirror.uoregon.edu/apache/hbase/hbase-#{node[:hbase][:version]}/hbase-#{node[:hbase][:version]}.tar.gz"
  owner "hadoop"
  group "hadoop"
  mode "0744"
  not_if "test -f #{node[:hadoop][:install_stage_dir]}/hbase-#{node[:hbase][:version]}.tar.gz"
end


# extract it
execute "extract-hbase" do
  command "tar -zxf hbase-#{node[:hbase][:version]}.tar.gz"
  creates "hbase-#{node[:hbase][:version]}"
  cwd "#{node[:hadoop][:install_stage_dir]}"
  user "hadoop"
  group "hadoop"
end


link "/usr/local/hbase" do
  to "#{node[:hadoop][:install_stage_dir]}/hbase-#{node[:hbase][:version]}"
end


# remove old hadoop core file, we run 0.20.205.0
file "/usr/local/hbase/lib/hadoop-core-0.20-append-r1056497.jar" do
  action :delete
end

# hbase needs right hadoop core
link "/usr/local/hbase/lib/hadoop-core-#{node[:hadoop][:version]}.jar" do
  to "/usr/share/hadoop/hadoop-core-#{node[:hadoop][:version]}.jar"
end

# manage hadoop configs
%w[masters regionservers hbase-env.sh hbase-site.xml log4j.properties].each do |template_file|
  template "/usr/local/hbase/conf/#{template_file}" do
    source "#{template_file}"
    mode 0755
    variables(
      :namenode => hadoop_namenode, # from hadoop recipe
      :hmaster => hmaster,
      :regionservers => regionservers
    )
  end
end

