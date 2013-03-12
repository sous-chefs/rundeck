#
# Cookbook Name:: vmware-tools
# Recipe:: default
#
# Copyright 2011, Bryan W. Berry <bryan.berry@gmail.com>
#
# Apache v2.0
#

if node['virtualization']['system'] == 'vmware'

  bash "remove_vmware_tools" do
    code <<-EOH
    yum remove -y 'vmware*'
    if [ -f /etc/yum.repos.d/vmware-tools.repo ]; then
      rm -f /etc/yum.repos.d/vmware-tools.repo
    fi
    if [ -d /usr/lib/vmware-tools ]; then
      rm -rf /usr/lib/vmware-tools
    fi
    if [ -d /etc/vmware-tools ]; then
      rm -rf /etc/vmware-tools
    fi
    EOH
    only_if "yum -C list installed 'vmware-tool*'"
  end

  unless File.directory?('/usr/lib/vmware-tools')

    # get the file
    remote_file "#{Chef::Config[:file_cache_path]}/#{node['esx']['tarball']}" do
      source "#{node['esx']['repo']}/#{node['esx']['tarball']}"
      checksum "#{node['esx']['checksum']}"
      mode 00644
    end
  
    # extract tarball
    execute 'extract' do
      command "tar xzf #{Chef::Config[:file_cache_path]}/#{node['esx']['tarball']}"
      cwd '/tmp'
    end
  
    # run uninstall script
    execute 'vmware-uninstall-tools.pl' do
      command '/tmp/vmware-tools-distrib/bin/vmware-uninstall-tools.pl'
      ignore_failure true
    end
  
    # run install script
    execute 'vmware-install.pl' do
      command '/tmp/vmware-tools-distrib/vmware-install.pl --default'
      notifies :delete, 'directory[/tmp/vmware-tools-distrib]'
    end

    # start the service
    service 'vmware-tools' do
      provider Chef::Provider::Service::Upstart
      action :start
    end

    # clean up
    directory '/tmp/vmware-tools-distrib' do
      recursive true
      action :nothing
    end

  end

end
