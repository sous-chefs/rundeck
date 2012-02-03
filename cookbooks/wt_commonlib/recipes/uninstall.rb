logdir = node['webtrends']['logdir']
installdir = node['webtrends']['installdir']
archive_url = node['webtrends']['archive_server']

pod = node.chef_environment
pod_data = data_bag_item('common', pod)
master_host = pod_data['master_host']

common_install_url = node['webtrends']['commonlib']['common_install_url']
msi_name = node['webtrends']['commonlib']['commonlib_msi']

directory logdir do
	action :create
end

remote_file "#{Chef::Config[:file_cache_path]}\\#{msi_name}" do
        source "#{archive_url}#{common_install_url}"
        action :nothing
end

http_request "HEAD #{archive_url}" do
  message ""
  url archive_url
  action :head
  if File.exists?("#{Chef::Config[:file_cache_path]}\\#{msi_name}")
    headers "If-Modified-Since" => File.mtime("#{Chef::Config[:file_cache_path]}\\#{msi_name}").httpdate
  end
  notifies :create, resources(:remote_file => "#{Chef::Config[:file_cache_path]}\\#{msi_name}"), :immediately
end


windows_package "WebTrends Common Lib" do
        source "#{Chef::Config[:file_cache_path]}\\#{msi_name}"
        options "/l*v \"#{logdir}\\#{msi_name}-Uninstall.log\""
        action :remove
end