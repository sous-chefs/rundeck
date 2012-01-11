pod = node['webtrends']['pod']

pod_data = data_bag_item('pods', pod)
dx_data = data_bag_item('dx', pod)

endpoint = dx_data['endpoint_address']
cass_hosts = pod_data['cassandra_hosts'].map {|x| "Name:" + x}
cass_hosts = "{#{cass_hosts.to_json}}"

#Recipe specific
cfg_cmds = node['webtrends']['dx']['v3']['cfg_cmd']
streamingservices_pool = node['webtrends']['dx']['v3']['streamingservices']['app_pool']
webservices_pool = node['webtrends']['dx']['v3']['webservices']['app_pool']
installdir = node['webtrends']['installdir']
installdir_v3 = node['webtrends']['dx']['v3']['dir']

template "#{installdir}#{installdir_v3}\\StreamingServices\\Web.config" do
	source "webConfigv3Streaming.erb"
	variables(
		:cache_hosts => pod_data['cache_hosts'],
		:master_host => pod_data['master_host']
	)
end

template "#{installdir}#{installdir_v3}\\Web Services\\Web.config" do
	source "webConfigv3Web.erb"
	variables(
		:cache_hosts => pod_data['cache_hosts'],
		:cassandra_hosts => pod_data['cassandra_hosts'],
		:master_host => pod_data['master_host'],
		:report_col => pod_data['cassandra_report_column'],
		:metadata_col => pod_data['cassandra_meta_column'],
		:snmp_comm => pod_data['cassandra_snmp_comm'],
		:cache_name => dx_data['cachename'],
		:endpoint_address => dx_data['endpoint_address'],
		:streamingservice_root => dx_data['app_settings_section']['streamingServiceRoot']
	)
end

iis_pool "#{streamingservices_pool}" do
	thirty_two_bit :true
	pipeline_mode :Integrated
  action [:add, :config]
end

iis_pool "#{webservices_pool}" do
	thirty_two_bit :true
	pipeline_mode :Integrated
  action [:add, :config]
end

iis_app "DX" do
	path "/StreamingServices_v3"
	application_pool "#{streamingservices_pool}"
	physical_path "#{installdir}#{installdir_v3}\\StreamingServices"
	action :add
end

iis_app "DX" do
	path "/v3"
	application_pool "#{webservices_pool}"
	physical_path "#{installdir}#{installdir_v3}\\Web Services"
	action :add
end

ruby_block "v3cfg_flag" do
	block do
		node.set['dxv3_configured']
		node.save
	end
	action :nothing
end

iis_config "\"DX/v3\" -section:system.webServer/handlers /+\"[name='svc-ISAPI-2.0_64bit',path='*.SVC',verb='*',modules='IsapiModule',scriptProcessor='C:\\Windows\\Microsoft.NET\\Framework\\v2.0.50727\\aspnet_isapi.dll']\"" do
	action :config	
	notifies :create, "ruby_block[v3cfg_flag]" #Running delayed notification so multiple run-once commands get run
	not_if {node.attribute?("dxv3_configured")}
end

iis_config "\"DX/v3\" -section:system.webServer/handlers /+\"[name='svc-ISAPI-2.0_32bit',path='*.SVC',verb='*',modules='IsapiModule',scriptProcessor='C:\\Windows\\Microsoft.NET\\Framework\\v2.0.50727\\aspnet_isapi.dll']" do
	action :config	
	notifies :create, "ruby_block[v3cfg_flag]" #Running delayed notification so multiple run-once commands get run
	not_if {node.attribute?("dxv3_configured")}
end

iis_config "\"DX/StreamingServices_v3\" -section:system.webServer/handlers /+\"[name='svc-ISAPI-2.0_64bit',path='*.SVC',verb='*',modules='IsapiModule',scriptProcessor='C:\\Windows\\Microsoft.NET\\Framework\\v2.0.50727\\aspnet_isapi.dll']\"" do
	action :config	
	notifies :create, "ruby_block[v3cfg_flag]" #Running delayed notification so multiple run-once commands get run
	not_if {node.attribute?("dxv3_configured")}
end

iis_config "\"DX/StreamingServices_v3\" -section:system.webServer/handlers /+\"[name='svc-ISAPI-2.0_32bit',path='*.SVC',verb='*',modules='IsapiModule',scriptProcessor='C:\\Windows\\Microsoft.NET\\Framework\\v2.0.50727\\aspnet_isapi.dll']" do
	action :config	
	notifies :create, "ruby_block[v3cfg_flag]" #Running delayed notification so multiple run-once commands get run
	not_if {node.attribute?("dxv3_configured")}
end