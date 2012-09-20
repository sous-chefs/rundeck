#
# Cookbook Name::splunk
# Recipe::server
#
# Copyright 2011-2012, BBY Solutions, Inc.
# Copyright 2011-2012, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

  splunk_cmd = "#{node['splunk']['server_home']}/bin/splunk"
  splunk_package_version = "splunk-#{node['splunk']['server_version']}-#{node['splunk']['server_build']}"

  splunk_file = splunk_package_version + 
    case node['platform']
    when "centos","redhat","fedora"
      if node['kernel']['machine'] == "x86_64"
        "-linux-2.6-x86_64.rpm"
      else
        ".i386.rpm"
      end
    when "debian","ubuntu"
      if node['kernel']['machine'] == "x86_64"
        "-linux-2.6-amd64.deb"
      else
        "-linux-2.6-intel.deb"
      end
    end

  remote_file "/opt/#{splunk_file}" do
    source "#{node['splunk']['server_root']}/#{node['splunk']['server_version']}/splunk/linux/#{splunk_file}"
    action :create_if_missing
  end

  package splunk_package_version do
    source "/opt/#{splunk_file}"
    case node['platform']
    when "centos","redhat","fedora"
      provider Chef::Provider::Package::Rpm
    when "debian","ubuntu"
      provider Chef::Provider::Package::Dpkg
    end
  end


  template "#{node['splunk']['server_home']}/etc/splunk-launch.conf" do
      source "server/splunk-launch.conf.erb"
      mode "0640"
      owner "root"
      group "root"
  end

  if node['splunk']['use_ssl']
    
    directory "#{node['splunk']['server_home']}/ssl" do
      owner "root"
      group "root"
      mode "0755"
      action :create
      recursive true
    end

    cookbook_file "#{node['splunk']['server_home']}/ssl/#{node['splunk']['ssl_crt']}" do
      source "ssl/#{node['splunk']['ssl_crt']}"
      mode "0755"
      owner "root"
      group "root"
    end

    cookbook_file "#{node['splunk']['server_home']}/ssl/#{node['splunk']['ssl_key']}" do
      source "ssl/#{node['splunk']['ssl_key']}"
      mode "0755"
      owner "root"
      group "root"
    end

  end
  
  execute "#{splunk_cmd} start --accept-license --answer-yes" do
    not_if do
      `#{splunk_cmd} status | grep 'splunkd'`.chomp! =~ /^splunkd is running/
    end
  end

  execute "#{splunk_cmd} enable boot-start" do
    not_if do
      File.symlink?('/etc/rc3.d/S20splunk')
    end
  end

  splunk_password = node['splunk']['auth'].split(':')[1]
  execute "#{splunk_cmd} edit user admin -password #{splunk_password} -roles admin -auth admin:changeme && echo true > /opt/splunk_setup_passwd" do
    not_if do
      File.exists?("/opt/splunk_setup_passwd")
    end
  end

  execute "#{splunk_cmd} enable listen #{node['splunk']['receiver_port']} -auth #{node['splunk']['auth']}" do
    not_if "netstat -a | grep #{node['splunk']['receiver_port']}"
  end

  service "splunk" do
    action [ :nothing ]
    supports  :status => true, :start => true, :stop => true, :restart => true
  end

  node['splunk']['static_server_configs'].each do |cfg|
      template "#{node['splunk']['server_home']}/etc/system/local/#{cfg}.conf" do
       	source "server/#{cfg}.conf.erb"
       	owner "root"
       	group "root"
       	mode "0640"
        notifies :restart, resources(:service => "splunk")
       end
  end
  
  node['splunk']['dynamic_server_configs'].each do |cfg|
    template "#{node['splunk']['server_home']}/etc/system/local/#{cfg}.conf" do
     	source "server/#{node['splunk']['server_config_folder']}/#{cfg}.conf.erb"
     	owner "root"
     	group "root"
     	mode "0640"
      notifies :restart, resources(:service => "splunk")
     end
  end
 
  
  template "/etc/init.d/splunk" do
      source "server/splunk.erb"
      mode "0755"
      owner "root"
      group "root"
  end

  directory "#{node['splunk']['server_home']}/etc/users/admin/search/local/data/ui/views" do
    owner "root"
    group "root"
    mode "0755"
    action :create
    recursive true
  end

  if node['splunk']['deploy_dashboards'] == true
    node['splunk']['dashboards_to_deploy'].each do |dashboard|
      cookbook_file "#{node['splunk']['server_home']}/etc/users/admin/search/local/data/ui/views/#{dashboard}.xml" do
        source "dashboards/#{dashboard}.xml"
      end
    end
  end

