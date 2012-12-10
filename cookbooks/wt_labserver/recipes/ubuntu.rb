#
# Cookbook Name:: wt_labserver
# Recipe:: ubuntu
#
# Copyright 2012, Webtrends Inc.
#
# All rights reserved - Do Not Redistribute
#

# import trusted ca certificates
java_home = '/usr/lib/jvm/default-java'
%w{ pdxca01 pdxengca01 }.each do |ca|

	cookbook_file "#{Chef::Config[:file_cache_path]}/#{ca}.cer" do
		source "#{ca}.cer"
		mode 00600
		action :create_if_missing
		only_if { File.exists?("#{java_home}/bin/keytool") }
	end

	execute "keytool import #{ca}" do
		command "#{java_home}/bin/keytool -import -trustcacerts -alias #{ca} -file #{Chef::Config[:file_cache_path]}/#{ca}.cer -keystore #{java_home}/jre/lib/security/cacerts -storepass changeit -noprompt"
		only_if { File.exists?("#{java_home}/bin/keytool") }
		not_if  "#{java_home}/bin/keytool -list -alias #{ca} -keystore #{java_home}/jre/lib/security/cacerts -storepass changeit"
	end

end
