version = node[:graphite][:version]

remote_file "/usr/src/carbon-#{version}.tar.gz" do
  source node[:graphite][:carbon][:uri]
  checksum node[:graphite][:carbon][:checksum]
end

execute "untar carbon" do
  command "tar xzf carbon-#{version}.tar.gz"
  creates "/usr/src/carbon-#{version}"
  cwd "/usr/src"
end

execute "install carbon" do
  command "python setup.py install"
  creates "/opt/graphite/lib/carbon-#{version}-py2.6.egg-info"
  cwd "/usr/src/carbon-#{version}"
end

case node[:platform]
when "centos","redhat"
  apache_user = "apache"
when "debian","ubuntu"
  apache_user = "www-data"
end

service "carbon-cache" do
  supports :restart => true, :start => true, :stop => true, :reload => true, :status => true
  action :nothing
end

template "/etc/init.d/carbon-cache" do
  source "carbon-cache.init"
  owner "root"
  group "root"
  mode "0755"
  notifies :enable, "service[carbon-cache]"
  notifies :start, "service[carbon-cache]"
end

template "/opt/graphite/conf/carbon.conf" do
  owner "#{apache_user}"
  group "#{apache_user}"
  variables( :local_data_dir => node[:graphite][:carbon][:local_data_dir],
             :line_receiver_interface => node[:graphite][:carbon][:line_receiver_interface],
             :pickle_receiver_interface => node[:graphite][:carbon][:pickle_receiver_interface],
             :cache_query_interface => node[:graphite][:carbon][:cache_query_interface] )
  mode "0644"
  notifies :restart, "service[carbon-cache]"
end

template "/opt/graphite/conf/storage-schemas.conf" do
  owner "#{apache_user}"
  group "#{apache_user}"
  mode "0644"
end

execute "carbon: change graphite storage permissions to www-data" do
  command "chown -R www-data:www-data /opt/graphite/storage"
  only_if do
    f = File.stat("/opt/graphite/storage")
    f.uid == 0 and f.gid == 0
  end
end

directory "/opt/graphite/lib/twisted/plugins/" do
  owner "#{apache_user}"
  group "#{apache_user}"
end

service "carbon-cache" do
  action [:enable, :start]
end
