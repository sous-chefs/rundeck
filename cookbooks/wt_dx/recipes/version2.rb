c_hosts = node['wt_common']['cache_hosts']


#Recipe specific
cfg_cmds = node['wt_dx']['v2']['cfg_cmd']
app_pool = node['wt_dx']['v2']['app_pool']
installdir = node['wt_common']['installdir']
installdir_v2 = node['wt_dx']['v2']['dir']

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