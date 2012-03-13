
include_recipe "nginx"

=begin

we need a deb repo


# install heatmap deb
cookbook_file "/usr/local/share/heatmaps_0.0.1_amd64.deb" do
  source "heatmaps_0.0.1_amd64.deb"
  owner "root"
  group "root"
  mode 0644
end

Execute "install-heatmaps" do
  command "dpkg -i /usr/local/share/heatmaps_0.0.1_amd64.deb"
  action :run
  not_if "dpkg --list | grep heatmap"
end

=end


thriftservers = Array.new
search(:node, "role:hadoop_datanode AND chef_environment:#{node.chef_environment}").each do |n|
    thriftservers << n[:fqdn]
end


template "/var/lib/php5/thriftservers.php" do
  source "apiserver/thriftservers.php"
  owner "www-data"
  group "www-data"
  mode "0744"
  variables(
    :thriftservers => thriftservers
  )
end


# setup webserver


template "#{node[:nginx][:dir]}/sites-available/apiserver" do
  source "apiserver/apiserver"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, resources(:service => "nginx")
end


remote_directory "/var/www" do
  source "apiserver-www"
  owner "www-data"
  group "www-data"
  files_owner "www-data"
  files_group "www-data"
  files_mode "0744"
  mode "0744"
end

nginx_site "default" do
  enable false
end

nginx_site "apiserver" do
  enable true
  notifies :restart, resources("service[nginx]","service[php-fastcgi]")
end


