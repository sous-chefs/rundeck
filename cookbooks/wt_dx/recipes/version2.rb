pod = node['webtrends']['pod']
pod_data = data_bag_item('pods', pod)
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

ruby_block "v2cfg_flag" do
	block do
		node.set['dxv2_configured']
		node.save
	end
	action :nothing
end

iis_config "\"DX/v2\" -section:system.webServer/handlers /+\"[name='svc-ISAPI-2.0_64bit',path='*.SVC',verb='*',modules='IsapiModule',scriptProcessor='C:\\Windows\\Microsoft.NET\\Framework\\v2.0.50727\\aspnet_isapi.dll']\"" do
	action :config	
	notifies :create, "ruby_block[v1cfg_flag]" #Running delayed notification so multiple run-once commands get run
	not_if {node.attribute?("dxv2_configured")}
end

iis_config "\"DX/v2\" -section:system.webServer/handlers /+\"[name='svc-ISAPI-2.0_32bit',path='*.SVC',verb='*',modules='IsapiModule',scriptProcessor='C:\\Windows\\Microsoft.NET\\Framework\\v2.0.50727\\aspnet_isapi.dll']" do
	action :config	
	notifies :create, "ruby_block[v1cfg_flag]" #Running delayed notification so multiple run-once commands get run
	not_if {node.attribute?("dxv2_configured")}
end