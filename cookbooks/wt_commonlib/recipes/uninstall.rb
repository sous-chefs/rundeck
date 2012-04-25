logdir = node['wt_common']['log_dir_windows']
msi_name = node['wt_commonlib']['commonlib_msi']

directory logdir do
	action :create
	recursive true
end

windows_package "WebTrends Common Lib" do
        source "#{Chef::Config[:file_cache_path]}\\#{msi_name}"
        options "/l*v \"#{logdir}\\#{msi_name}-Uninstall.log\""
        action :remove
end