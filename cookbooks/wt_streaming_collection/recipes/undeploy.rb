install_dir  =
"#{node['wt_common']['install_dir_linux']}/harness/plugins/streaming_collection"
 
directory install_dir do
 recursive true
 action :delete
end
