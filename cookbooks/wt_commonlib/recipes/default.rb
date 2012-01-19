logdir = node['webtrends']['logdir']
installdir = node['webtrends']['installdir']
pod = node['webtrends']['pod']
pod_data = data_bag_item('common', pod)
master_host = pod_data['master_host']
buildURLs = data_bag_item('buildURLs', 'latest')
build_url = buildURLs['url']
common_msi = node['webtrends']['common_msi']
common_msi_url = node['webtrends']['common_msi_url']

directory logdir do
	action :create
end

remote_file "#{Chef::Config[:file_cache_path]}\\#{common_msi}" do
        source "#{build_url}#{common_msi_url}"
        action :nothing
end

http_request "HEAD #{build_url}" do
  message ""
  url build_url
  action :head
  if File.exists?("#{Chef::Config[:file_cache_path]}\\#{common_msi}")
    headers "If-Modified-Since" => File.mtime("#{Chef::Config[:file_cache_path]}\\#{common_msi}").httpdate
  end
  notifies :create, resources(:remote_file => "#{Chef::Config[:file_cache_path]}\\#{common_msi}"), :immediately
end

windows_package "CommonLib" do
        source "#{Chef::Config[:file_cache_path]}\\#{common_msi}"
        options "/l*v \"#{logdir}\\#{common_msi}-Install.log\" INSTALLDIR=\"#{installdir}\" SQL_SERVER_NAME=\"#{master_host}\" WTMASTER=\"wtMaster\"  WTSCHED=\"wt_Sched\""
        action :install
end
