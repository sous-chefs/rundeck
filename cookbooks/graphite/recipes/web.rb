version = node[:graphite][:version]

include_recipe "apache2"
include_recipe "memcached::default"

# CentOS/RH prerequisites
if platform?("redhat", "centos")
  %w{ Django django-tagging mod_wsgi pycairo python-ldap }.each do |pkg|
    package pkg
  end
end

# Debian/Ubuntu prerequisites
if platform?("debian","ubuntu")
  %w{ apache2-mpm-worker apache2-utils apache2.2-bin apache2.2-common python-cairo python-django python-django-tagging python-ldap }.each do |pkg|
    package pkg
  end
end

case node[:platform]
when "centos","redhat"
  apache_user = "apache"
when "debian","ubuntu"
  apache_user = "www-data"
end

remote_file "/usr/src/graphite-web-#{version}.tar.gz" do
  source node[:graphite][:graphite_web][:uri]
  checksum node[:graphite][:graphite_web][:checksum]
end

execute "untar graphite-web" do
  command "tar xzf graphite-web-#{version}.tar.gz"
  creates "/usr/src/graphite-web-#{version}"
  cwd "/usr/src"
end

execute "install graphite-web" do
  command "python setup.py install"
  creates "/opt/graphite/webapp/graphite_web-#{version}-py2.6.egg-info"
  cwd "/usr/src/graphite-web-#{version}"
end

execute "setup graphite.wsgi" do
  command "cp graphite.wsgi.example graphite.wsgi"
  creates "/opt/graphite/conf/graphite.wsgi"
  cwd "/opt/graphite/conf"
end

template "/opt/graphite/webapp/graphite/local_settings.py" do
  source "local_settings.py.erb"
  variables( :web_app_timezone => node[:graphite][:web_app_timezone],
             :local_data_dirs => node[:graphite][:carbon][:local_data_dir] )
  notifies :restart, resources(:service => "apache2")
end

# Setup the apache site for Graphite

# CentOS/RH
if platform?("redhat", "centos")
  template "/etc/httpd/sites-available/default" do
    source "graphite-vhost.conf.erb"
    variables( :django_media_dir => "/usr/lib/python2.6/site-packages/django/contrib/admin/media/" )
    notifies :restart, resources(:service => "apache2")
  end
end

# Debian/Ubuntu
if platform?("debian","ubuntu")
  template "/etc/apache2/sites-available/default" do
    source "graphite-vhost.conf.erb"
    variables( :django_media_dir => "/usr/share/pyshared/django/contrib/admin/media/" )
    notifies :restart, resources(:service => "apache2")
  end
end

directory "/opt/graphite/storage/log" do
  owner "#{apache_user}"
  group "#{apache_user}"
end

directory "/opt/graphite/storage/log/webapp" do
  owner "#{apache_user}"
  group "#{apache_user}"
end

directory "/opt/graphite/storage" do
  owner "#{apache_user}"
  group "#{apache_user}"
end

directory "/opt/graphite/storage/whisper" do
  owner "#{apache_user}"
  group "#{apache_user}"
end

cookbook_file "/opt/graphite/bin/set_admin_passwd.py" do
  mode "755"
end

cookbook_file "/opt/graphite/storage/graphite.db" do
  action :create_if_missing
  notifies :run, "execute[set admin password]"
end

execute "set admin password" do
  command "/opt/graphite/bin/set_admin_passwd.py root #{node[:graphite][:password]}"
  action :nothing
end

file "/opt/graphite/storage/graphite.db" do
  owner "#{apache_user}"
  group "#{apache_user}"
  mode "644"
end
