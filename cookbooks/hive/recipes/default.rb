
hivemeta = search(:node, "role:hivemeta")
hivemeta = hivemeta.length == 1 ? hivemeta.first[:fqdn] : "localhost"

include_recipe "hadoop"

# determine metastore jdbc properties
metastore_prefix = "none"
metastore_driver = "none"

if node[:hive][:metastore][:connector] == "mysql"
  metastore_prefix = "mysql"
  metastore_driver = "com.mysql.jdbc.Driver"
end

if node[:hive][:metastore][:connector] == "sqlserver"
  metastore_prefix = "sqlserver"
  metastore_driver = "com.microsoft.sqlserver.jdbc.SQLServerDriver"
  if node[:wt_common][:usage_host] != nil
    hivemeta = node[:wt_common][:usage_host]
  end
end


# download hive
remote_file "#{node[:hadoop][:install_stage_dir]}/hive-#{node[:hive][:version]}-bin.tar.gz" do
  source "http://mirror.uoregon.edu/apache/hive/hive-#{node[:hive][:version]}/hive-#{node[:hive][:version]}-bin.tar.gz"
  owner "hadoop"
  group "hadoop"
  mode "0744"
  not_if "test -f #{node[:hadoop][:install_stage_dir]}/hive-#{node[:hive][:version]}-bin.tar.gz"
end


# extract it
execute "extract-hive" do
  command "tar -zxf hive-#{node[:hive][:version]}-bin.tar.gz"
  creates "hive-#{node[:hbase][:version]}"
  cwd "#{node[:hadoop][:install_stage_dir]}"
  user "hadoop"
  group "hadoop"
end

link "/usr/local/hive" do
  to "#{node[:hadoop][:install_stage_dir]}/hive-#{node[:hive][:version]}-bin"
end


# jdbc connectors
%w[mysql-connector-java.jar sqljdbc4.jar].each do |jar|
  cookbook_file "/usr/local/hive/lib/#{jar}" do
    source "#{jar}"
    owner "hadoop"
    group "hadoop"
    mode 0644
  end
end


# templates
%w[hive-site.xml hive-env.sh hive-exec-log4j.properties hive-log4j.properties].each do |template_file|
  template "/usr/local/hive/conf/#{template_file}" do
    source "#{template_file}"
    mode 0755
    variables(
      :hivemeta => hivemeta,
      :metastore_prefix => metastore_prefix,
      :metastore_driver => metastore_driver,
      :dbuser => node[:hive][:metastore][:dbuser],
      :dbpass => node[:hive][:metastore][:dbpass]
    )
  end

  # remove default template files
  file "/usr/local/hive/conf/#{template_file}.template" do
    action :delete
  end
end


# remove old jars
%w[hbase-0.89.0-SNAPSHOT.jar hbase-0.89.0-SNAPSHOT-tests.jar].each do |template_file|
  file "/usr/local/hive/lib/#{template_file}" do
    action :delete
  end
end

link "/usr/local/hive/lib/hbase-0.92.0.jar" do
  to "/usr/local/hbase/hbase-0.92.0.jar"
end


