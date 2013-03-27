
# Cookbook Name:: wt_labserver
# Recipe:: import_certs
#
# Copyright 2012, Webtrends Inc.
#
# All rights reserved - Do Not Redistribute
#

# import trusted ca certificates
java_home = node['java']['java_home']
%w{ pdxca01 pdxengca01 }.each do |ca|

	cookbook_file "#{Chef::Config[:file_cache_path]}/#{ca}.cer" do
		source "#{ca}.cer"
		mode 00600
		action :create_if_missing
		only_if { File.exists?("#{java_home}/bin/keytool") }
	end

	#Imports into java
	execute "keytool import #{ca}" do
		command "#{java_home}/bin/keytool -import -trustcacerts -alias #{ca} -file #{Chef::Config[:file_cache_path]}/#{ca}.cer -keystore #{java_home}/jre/lib/security/cacerts -storepass changeit -noprompt"
		only_if { File.exists?("#{java_home}/bin/keytool") }
		not_if  "#{java_home}/bin/keytool -list -alias #{ca} -keystore #{java_home}/jre/lib/security/cacerts -storepass changeit"
	end

	#imports into system keystore
	execute "Convert #{ca} into pem format" do
		command "openssl x509 -inform DER -outform PEM -in #{Chef::Config[:file_cache_path]}/#{ca}.cer -out #{Chef::Config[:file_cache_path]}/#{ca}.pem"
		not_if {File.exists?("#{Chef::Config[:file_cache_path]}/#{ca}.pem")}
	end
	
	execute "Copy #{ca} to cert folder" do
		command "cp #{Chef::Config[:file_cache_path]}/#{ca}.pem /etc/ssl/certs"
		not_if {File.exists?("/etc/ssl/certs/#{ca}.pem")}
	end
	
	link "/etc/ssl/certs/#{ca}.pem" do
		to "`openssl x509 -hash -noout -in #{ca}.pem`.0"
	end	

end