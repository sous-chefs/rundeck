c_hosts = node['wt_common']['cache_hosts']

#Recipe specific
cfg_cmds = node['wt_dx']['v2_2']['cfg_cmd']
app_pool = node['wt_dx']['v2_2']['app_pool']
installdir = node['wt_common']['installdir']
installdir_v22 = node['wt_dx']['v2_2']['dir']

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