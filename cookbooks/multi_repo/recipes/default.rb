#
# Cookbook Name:: multi_repo
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# Install packages needed to manage repos
package "nfs-common"
package "reprepro"
package "createrepo"

# install apache2 to host the repo
include_recipe "apache2"

# disable the default apache site
apache_site "000-default" do
  enable false
end

# create the repo directory
directory "#{node['multi_repo']['repo_path']}" do
  recursive true
end

# template the apache config for the repo site
template "#{node['apache']['dir']}/sites-available/repo.conf" do
  source "apache2.conf.erb"
  mode 00644
  variables(:docroot => node['multi_repo']['repo_path'])
  if ::File.symlink?("#{node['apache']['dir']}/sites-enabled/repo.conf")
    notifies :reload, resources(:service => "apache2")
  end
end

# mount the NFS mount on the repo
mount "#{node['multi_repo']['repo_path']}" do
  device "#{node['multi_repo']['repo_mount']}"
  fstype "nfs"
  options "rw"
  action [:mount, :enable]
end
  
# create the apache site
apache_site "repo" do
  ignore_failure true
  action :create
end
