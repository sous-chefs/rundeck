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

  #get the file
  remote_file "#{Chef::Config[:file_cache_path]}/#{node['esx']['tarball']}" do
    source "#{node['esx']['repo']}/#{node['esx']['tarball']}"
    checksum "#{node['esx']['checksum']}"
    mode 00644
    only_if "test ! -d /usr/lib/vmware-tools"
  end

  # install vmware-tools
  bash "install_vmware_tools" do
    code <<-EOH
    cd /tmp
    test -f VMware* && rm -rf VMware*
    tar xvzf #{Chef::Config[:file_cache_path]}/#{node['esx']['tarball']} -C /tmp
    pushd vmware-tools*
    ./vmware-install.pl --default
    popd
    rm -rf vmware-tools*
    EOH
    only_if "test ! -d /usr/lib/vmware-tools"
  end

end
