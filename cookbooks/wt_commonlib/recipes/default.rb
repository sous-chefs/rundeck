logdir = node['wt_common']['log_dir_windows']
installdir = node['wt_common']['install_dir_windows']
archive_url = node['wt_common']['archive_server']
master_host = node['wt_common']['master_host']
common_install_url = node['wt_commonlib']['common_install_url']
msi_name = node['wt_commonlib']['commonlib_msi']

directory logdir do
	action :create
	recursive true
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
        options "/l*v \"#{logdir}\\#{msi_name}-Install.log\" INSTALLDIR=\"#{installdir}\" SQL_SERVER_NAME=\"#{master_host}\" WTMASTER=\"wtMaster\"  WTSCHED=\"wt_Sched\""
        action :install
end