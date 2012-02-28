c_hosts = node['wt_common']['cache_hosts']

#Recipe specific
cfg_cmds = node['wt_dx']['v1_1']['cfg_cmd']
app_pool = node['wt_dx']['v1_1']['app_pool']
installdir = node['wt_common']['installdir']
installdir_v1 = node['wt_dx']['v1_1']['dir']

pod = node.chef_environment
user_data = data_bag_item('authorization', pod)
ui_user = user_data['wt_common']['ui_user']
ui_password = user_data['wt_common']['ui_pass']
auth_cmd = "/section:applicationPools /[name='#{app_pool}'].processModel.identityType:SpecificUser /[name='#{app_pool}'].processModel.userName:#{ui_user} /[name='#{app_pool}'].processModel.password:#{ui_password}"

template "#{installdir}#{installdir_v1}\\web.config" do
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
	physical_path "#{installdir}#{installdir_v1}"
	action :add
end

iis_config auth_cmd do
	action :config
end