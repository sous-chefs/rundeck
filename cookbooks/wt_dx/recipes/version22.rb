pod = node['webtrends']['pod']
pod_data = data_bag_item('common', pod)
c_hosts = pod_data['cache_hosts']


#Recipe specific
cfg_cmds = node['webtrends']['dx']['v2_2']['cfg_cmd']
app_pool = node['webtrends']['dx']['v2_2']['app_pool']
installdir = node['webtrends']['installdir']
installdir_v22 = node['webtrends']['dx']['v2_2']['dir']

template "#{installdir}#{installdir_v22}\\web.config" do
	source "webConfigv22.erb"
	variables(
		:cache_hosts => c_hosts
	)
end

iis_pool "#{app_pool}" do
	pipeline_mode :Integrated
	runtime_version "4.0"
	action [:add, :config]
end

iis_app "OEM_DX" do
	path "/v2_2"
	application_pool "#{app_pool}"
	physical_path "#{installdir}#{installdir_v22}"
	action :add
end