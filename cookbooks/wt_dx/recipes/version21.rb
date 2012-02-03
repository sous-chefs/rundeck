pod = node.chef_environment
pod_data = data_bag_item('common', pod)
c_hosts = pod_data['cache_hosts']


#Recipe specific
cfg_cmds = node['webtrends']['dx']['v2_1']['cfg_cmd']
app_pool = node['webtrends']['dx']['v2_1']['app_pool']
installdir = node['webtrends']['installdir']
installdir_v21 = node['webtrends']['dx']['v2_1']['dir']

template "#{installdir}#{installdir_v21}\\web.config" do
	source "webConfigv21.erb"
	variables(
		:cache_hosts => c_hosts
	)
end

iis_pool "#{app_pool}" do
	thirty_two_bit :true
action [:add, :config]
end

iis_app "DX" do
	path "/v2_1"
	application_pool "#{app_pool}"
	physical_path "#{installdir}#{installdir_v21}"
	action :add
end