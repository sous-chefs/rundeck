pod = node['webtrends']['pod']
pod_data = data_bag_item('pods', pod)
c_hosts = pod_data['cache_hosts']

#Generic
installdir = node['webtrends']['installdir']
buildURLs = data_bag("buildURLs")
build_url = data_bag_item('buildURLs', 'latest')
install_url = build_url['url']
install_url << "dx/"

#Recipe specific
cfg_cmds = node['webtrends']['dx']['v1_1']['cfg_cmd']
app_pool = node['webtrends']['dx']['v1_1']['app_pool']
install_url << node['webtrends']['dx']['v1_1']['file_name']
installdir << node['webtrends']['dx']['v1_1']['dir']


windows_zipfile "#{installdir}" do
	source "#{install_url}"
	action :unzip	
	not_if {::File.exists?("#{installdir}\\app.config")}
end

template "#{installdir}\\web.config" do
	source "webConfigv1.erb"
	variables(
		:cache_hosts => c_hosts
	)
end

iis_pool "#{app_pool}" do
	thirty_two_bit :true
action [:add, :config]
end

iis_app "DX" do
	path "/v1_1"
	application_pool "#{app_pool}"
	physical_path "#{installdir}"
end

iis_config "\"DX/v1_1\" -section:system.webServer/handlers /+\"[name='svc-ISAPI-2.0_64bit',path='*.SVC',verb='*',modules='IsapiModule',scriptProcessor='C:\\Windows\\Microsoft.NET\\Framework\\v2.0.50727\\aspnet_isapi.dll']\"" do
	action :config	
	notifies :create, "ruby_block[v1cfg_flag]" #Running delayed notification so multiple run-once commands get run
	not_if {node.attribute?("dxv1_configured")}
end

iis_config "DX/v1_1\" -section:system.webServer/handlers /+\"[name='svc-ISAPI-2.0_32bit',path='*.SVC',verb='*',modules='IsapiModule',scriptProcessor='C:\\Windows\\Microsoft.NET\\Framework\\v2.0.50727\\aspnet_isapi.dll']" do
	action :config	
	notifies :create, "ruby_block[v1cfg_flag]" #Running delayed notification so multiple run-once commands get run
	not_if {node.attribute?("dxv1_configured")}
end

ruby_block "v1cfg_flag" do
	block do
		node.set['dxv1_configured']
		node.save
	end
	action :nothing
end