include_recipe 'apache2'
include_recipe 'apache2::mod_deflate'
include_recipe 'apache2::mod_headers'
include_recipe 'apache2::mod_ssl' if node['rundeck']['use_ssl']
include_recipe 'apache2::mod_proxy'
include_recipe 'apache2::mod_proxy_http'


if node['rundeck']['use_ssl']
  cookbook_file "#{node['apache']['dir']}/ssl/#{node['rundeck']['cert']['name']}.crt" do
    cookbook node['rundeck']['cert']['cookbook']
    source "certs/#{node['rundeck']['cert']['name']}.crt"
    notifies :restart, 'service[apache2]'
  end

  cookbook_file "#{node['apache']['dir']}/ssl/#{node['rundeck']['cert']['name']}.key" do
    cookbook node['rundeck']['cert']['cookbook']
    source "certs/#{node['rundeck']['cert']['name']}.key"
    notifies :restart, 'service[apache2]'
  end

  cookbook_file "#{node['apache']['dir']}/ssl/#{node['rundeck']['cert']['ca_name']}.crt" do
    cookbook node['rundeck']['cert']['cookbook']
    source "certs/#{node['rundeck']['cert']['ca_name']}.crt"
    not_if { node['rundeck']['cert']['ca_name'].nil? }
    notifies :restart, 'service[apache2]'
  end
end


%w(default 000-default).each do |site|
  apache_site site do
    enable false
    notifies :reload, 'service[apache2]'
  end
end

template 'apache-config' do
  path "#{node['apache']['dir']}/sites-available/rundeck.conf"
  source 'rundeck.conf.erb'
  cookbook node['rundeck']['apache-template']['cookbook']
  mode 00644
  owner 'root'
  group 'root'
  variables(
            log_dir: node['platform_family'] == 'rhel' ? '/var/log/httpd' : '/var/log/apache2',
            doc_root: node['platform_family'] == 'rhel' ? '/var/www/html' : '/var/www'
            )
  notifies :reload, 'service[apache2]'
end

apache_site 'rundeck' do
  enable true
  notifies :reload, 'service[apache2]'
end