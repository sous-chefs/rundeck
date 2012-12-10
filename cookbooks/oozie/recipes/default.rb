#
# Cookbook Name:: oozie
# Recipe:: default
# Author:: Robert Towne(<robert.towne@webtrends.com>)
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
# this recipe installs oozie


if ENV["deploy_build"] == "true" then
  log "The deploy_build value is true so un-deploying first"
  include_recipe "oozie::undeploy"
else
  log "The deploy_build value is not set or is false so we will only update the configuration"
end


user         = node['hadoop']['default']['mapred']['cluster_administrators']
group        = node['hadoop']['default']['mapred_queue']['acl_submit_job']	    
tarball      = node['oozie']['download_url'].split("/")[-1]
download_url = node['oozie']['download_url']
install_dir  = node['oozie']['install_path']
log_dir      = node['oozie']['log_dir']
version      = node['oozie']['version']

log "User/Group:	#{user}\#{group}"
log "Install directory: #{install_dir}"
log "Downloaded from:   #{download_url}"
log "Filename:          #{tarball} (version=%{version})"


# create the log directory
directory log_dir do
  owner   user
  group   group
  mode    00755
  recursive true
  action :create
end

# create the install directory
directory "#{install_dir}/oozie-#{version}" do
  owner user
  group group
  mode 00755
  recursive true
  action :create
end


if ENV["deploy_build"] == "true" then
  log "The deploy_build value is true so we will grab the tar ball and install"


  package 'unzip' do
    action :install
  end

  package 'zip' do
    action :install
  end

  # download the application tarball
  remote_file "#{Chef::Config['file_cache_path']}/#{tarball}" do
    source download_url
    mode 00644
  end

  # uncompress the application tarbarll into the install dir
  execute "tar" do
    user  user
    group group
    cwd install_dir
    command "tar zxf #{Chef::Config[:file_cache_path]}/#{tarball}"
  end

  # delete the install tar ball
  execute "delete_install_source" do
    user "root"
    group "root"
    command "rm -f #{Chef::Config[:file_cache_path]}/#{tarball}"
    action :run
  end



  link "#{install_dir}/oozie" do
	to "#{install_dir}/oozie-#{version}"
	owner user
	group group
  end


  # jdbc connectors
  %w[mysql-connector-java.jar sqljdbc4.jar].each do |jar|
	cookbook_file "/usr/share/oozie/libext/#{jar}" do
		source "#{jar}"
		owner user
		group group
		mode 00644
	end
  end

  # create the log directory
  directory '/var/log/oozie' do
 	action :create
	owner user
	group group
	mode 00755
  end

  
  # make sure all templates and copied files now are owned correctly
  directory "#{install_dir}/oozie-#{version}" do
  	owner user
	group group
	mode 00755
	recursive true
	action :create
  end

  # this currently sets it up to use derby, will need to adjust once the MySQL recipe is working
  bash "final_setup" do
    interpreter "bash"
    user "root"
    cwd "/usr/share/oozie/bin"
    code <<-EOH
	ln -s /usr/share/hadoop/*.jar /usr/share/oozie/libext/
	/usr/share/oozie/bin/oozie-setup.sh
	/usr/share/oozie/bin/ooziedb.sh create -sqlfile /usr/share/oozie/bin/oozie.sql -run
	/usr/share/oozie/bin/oozie-start.sh
    EOH
  end




end


# configure templates
%w[oozie-env.sh].each do |template_file|
  template "#{install_dir}/oozie/conf/#{template_file}" do
	  source "#{template_file}.erb"
	  owner user
	  group group
	  mode  00644
  end
end



