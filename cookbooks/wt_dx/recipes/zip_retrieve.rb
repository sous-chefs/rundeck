buildURLs = data_bag("buildURLs")
build_url = data_bag_item('buildURLs', 'latest')
installdir = node['webtrends']['installdir']
install_url = build_url['url']

v1_install_url = node['webtrends']['dx']['v1_1']['file_name']
v1_installdir = node['webtrends']['dx']['v1_1']['dir']

v2_install_url = node['webtrends']['dx']['v2']['file_name']
v2_installdir = node['webtrends']['dx']['v2']['dir']


v21_install_url = node['webtrends']['dx']['v2_1']['file_name']
v21_installdir = node['webtrends']['dx']['v2_1']['dir']

v3_install_url = node['webtrends']['dx']['v3']['file_name']
v3_installdir = node['webtrends']['dx']['v3']['dir']

windows_zipfile "#{installdir}#{v1_installdir}" do
  source "#{install_url}dx/#{v1_install_url}"
  action :unzip	
  not_if {::File.exists?("#{installdir}#{v1_installdir}/web.config")}
end


windows_zipfile "#{installdir}#{v2_installdir}" do
  source "#{install_url}dx/#{v2_install_url}"
  action :unzip	
  not_if {::File.exists?("#{installdir}#{v21_installdir}/web.config")}
end

windows_zipfile "#{installdir}#{v21_installdir}" do
  source "#{install_url}dx/#{v21_install_url}"
  action :unzip	
  not_if {::File.exists?("#{installdir}#{v21_installdir}/web.config")}
end

windows_zipfile "#{installdir}#{v3_installdir}" do
  source "#{install_url}dx/#{v3_install_url}"
  action :unzip	
  not_if {::File.exists?("#{installdir}#{v3_installdir}//StreamingServices//log4net.config")}
end

#remote_file "#{Chef::Config[:file_cache_path]}\\#{v3_filename}" do
#        source "#{install_url}dx/#{v3_filename}"
#        action :create
#        not_if {::File.exists?("#{Chef::Config[:file_cache_path]}\\#{v3_filename}")}
#end