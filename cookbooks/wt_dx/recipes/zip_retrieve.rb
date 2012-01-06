pod = node['webtrends']['pod']
pod_data = data_bag_item('pods', pod)
c_hosts = pod_data['cache_hosts']

#Generic
buildURLs = data_bag("buildURLs")
build_url = data_bag_item('buildURLs', 'latest')


p node.webtrends.installdir
v1_installdir = node['webtrends']['installdir']
v1_install_url = build_url['url']
v1_install_url << "dx/"
v1_cfg_cmds = node['webtrends']['dx']['v1_1']['cfg_cmd']
v1_app_pool = node['webtrends']['dx']['v1_1']['app_pool']
v1_install_url << node['webtrends']['dx']['v1_1']['file_name']
v1_installdir << node['webtrends']['dx']['v1_1']['dir']
 
v2_installdir = node['webtrends']['installdir']
v2_install_url = build_url['url']
v2_install_url << "dx/"
v2_cfg_cmds = node['webtrends']['dx']['v2']['cfg_cmd']
v2_app_pool = node['webtrends']['dx']['v2']['app_pool']
v2_install_url << node['webtrends']['dx']['v2']['file_name']
v2_installdir << node['webtrends']['dx']['v2']['dir']

p node.webtrends.installdir

windows_zipfile "#{v1_installdir}" do
  source "#{v1_install_url}"
  action :unzip	
  not_if {::File.exists?("#{v1_installdir}\app.config")}
end

