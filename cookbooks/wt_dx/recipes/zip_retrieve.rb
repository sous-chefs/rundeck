buildURLs = data_bag("buildURLs")
build_url = data_bag_item('buildURLs', 'latest')
installdir = node['webtrends']['installdir']
install_url = build_url['url']

v1_install_url = node['webtrends']['dx']['v1_1']['file_name']
v1_installdir = node['webtrends']['dx']['v1_1']['dir']


windows_zipfile "#{installdir}#{v1_installdir}" do
  source "#{install_url}dx/#{v1_install_url}"
  action :unzip	
  not_if {::File.exists?("d:/wrs/Data Extraction API/v1_1/app.config")}
end

