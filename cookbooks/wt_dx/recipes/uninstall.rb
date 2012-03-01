v1pool = node['wt_dx']['v1_1']['app_pool']
v2pool = node['wt_dx']['v2']['app_pool']
v21pool = node['wt_dx']['v2_1']['app_pool']
v22pool = node['wt_dx']['v2_2']['app_pool']
streamingservices_pool = node['wt_dx']['v3']['streamingservices']['app_pool']
webservices_pool = node['wt_dx']['v3']['webservices']['app_pool']
dx_dir = "#{node['wt_common']['installdir']}\\Data Extraction API"
oem_dir = "#{node['wt_common']['installdir']}\\OEM Data Extraction API"

iis_app "DX" do
	path "/v1_1"
	application_pool "#{v1pool}"
	action :delete
end

iis_pool "#{v1pool}" do
  action [:stop, :delete]
end

iis_app "DX" do
	path "/v2"
	application_pool "#{v2pool}"
	action :delete
end

iis_pool "#{v2pool}" do
  action [:stop, :delete]
end

iis_app "DX" do
	path "/v2_1"
	application_pool "#{v21pool}"
	action :delete
end

iis_pool "#{v21pool}" do
  action [:stop, :delete]
end

iis_app "OEM_DX" do
	path "/v2_2"
	application_pool "#{v22pool}"
	action :delete
end

iis_pool "#{v22pool}" do
  action [:stop, :delete]
end

iis_app "DX" do
	path "/StreamingServices_v3"
	application_pool "#{streamingservices_pool}"
	action :delete
end

iis_app "DX" do
	path "/v3"
	application_pool "#{webservices_pool}"
	action :delete
end

iis_pool "#{streamingservices_pool}" do
	action [:stop, :delete]
end

iis_pool "#{webservices_pool}" do
	action [:stop, :delete]
end

iis_site 'DX' do
	action [:stop, :delete]
end

iis_site 'OEM_DX' do
	action [:stop, :delete]
end

execute "iisreset" do
	command "iisreset"
end

directory "#{dx_dir}" do
  recursive true
  action :delete
end

directory "#{oem_dir}" do
  recursive true
  action :delete
end

ruby_block "update_node_version" do
  block do      
    node.set['wt_dx']['build_version'] = nil
    node.save
  end
end
