endpoint = node['wt_dx']['endpoint_address']
cass_hosts = node['wt_common']['cassandra_hosts'].map {|x| "Name:" + x}
cass_hosts = "{#{cass_hosts.to_json}}"

#Recipe specific
cfg_cmds = node['wt_dx']['v3']['cfg_cmd']
streamingservices_pool = node['wt_dx']['v3']['streamingservices']['app_pool']
webservices_pool = node['wt_dx']['v3']['webservices']['app_pool']
installdir = node['wt_common']['installdir']
installdir_v3 = node['wt_dx']['v3']['dir']

template "#{installdir}#{installdir_v3}\\StreamingServices\\Web.config" do
	source "webConfigv3Streaming.erb"
	variables(
		:cache_hosts => node['wt_common']['cache_hosts'],
		:master_host => node['wt_common']['master_host']
	)
end

template "#{installdir}#{installdir_v3}\\Web Services\\Web.config" do
	source "webConfigv3Web.erb"
	variables(
		:cache_hosts => node['wt_common']['cache_hosts'],
		:cassandra_hosts => node['wt_common']['cassandra_hosts'],
		:master_host => node['wt_common']['master_host'],
		:report_col => node['wt_common']['cassandra_report_column'],
		:metadata_col => node['wt_common']['cassandra_meta_column'],
		:snmp_comm => node['wt_common']['cassandra_snmp_comm'],
		:cache_name => node['wt_dx']['cachename'],
		:endpoint_address => node['wt_dx']['endpoint_address'],
		:streamingservice_root => node['wt_dx']['app_settings_section']['streamingServiceRoot']
	)
end

iis_pool "#{streamingservices_pool}" do
	pipeline_mode :Integrated
  action [:add, :config]
end

iis_pool "#{webservices_pool}" do
	pipeline_mode :Integrated
	runtime_version "4.0"
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