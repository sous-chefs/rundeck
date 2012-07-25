#
# Cookbook Name:: vsftpd
# Recipe:: default
#
# Copyright 2010, Robert J. Berger
#
# Apache License, Version 2.0
#

package "vsftpd"

service "vsftpd" do
  supports :status => true, :restart => true
  action [ :enable, :start ]
end

if node[:vsftpd][:use_ssl_certs_from_cookbook]
  cookbook_file "#{node[:vsftpd][:ssl_cert_path]}/#{node[:vsftpd][:ssl_certs_basename]}.pem" do
    owner 'root'
    group 'root'
    mode 0600
  end

  cookbook_file "#{node[:vsftpd][:ssl_private_key_path]}/#{node[:vsftpd][:ssl_certs_basename]}.key" do
    owner 'root'
    group 'root'
    mode 0600
  end
end

template "/etc/vsftpd.chroot_list" do
  source "vsftpd.chroot_list"
  owner "root"
  group "root"
  mode 0644
  variables(:users => node[:vsftpd][:chroot_users])
end

template "/etc/vsftpd.conf" do
  source "vsftpd.conf"
  owner "root"
  group "root"
  mode 0644
  variables(
    :ssl_cert_path => node[:vsftpd][:ssl_cert_path],
    :ssl_private_key_path => node[:vsftpd][:ssl_private_key_path],
    :ssl_certs_basename => node[:vsftpd][:ssl_certs_basename],
    :chroot_local_user => node[:vsftpd][:chroot_local_user]
  )
  notifies :restart, resources(:service => "vsftpd")
end

