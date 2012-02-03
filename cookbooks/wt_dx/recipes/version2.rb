pod = pod = node.chef_environment
pod_data = data_bag_item('common', pod)
c_hosts = pod_data['cache_hosts']


#Recipe specific
cfg_cmds = node['webtrends']['dx']['v2']['cfg_cmd']
app_pool = node['webtrends']['dx']['v2']['app_pool']
installdir = node['webtrends']['installdir']
installdir_v2 = node['webtrends']['dx']['v2']['dir']

template "#{installdir}#{installdir_v2}\\web.config" do
	source "webConfigv2.erb"
	variables(
		:cache_hosts => c_hosts
	)
end

iis_pool "#{app_pool}" do
	thirty_two_bit :true
action [:add, :config]
end

iis_app "DX" do
	path "/v2"
	application_pool "#{app_pool}"
	physical_path "#{installdir}#{installdir_v2}"
	action :add
end