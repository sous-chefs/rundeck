# import trusted ca certificates
java_home = node['java']['java_home']
repo = node['wt_common']['ca_repo']
if ['wt_common']['ca_files']
	node['wt_common']['ca_files'].each do |ca|

		remote_file "#{Chef::Config[:file_cache_path]}/#{ca}.cer" do
		   source "#{repo}/#{ca}.cer"
		 end
		
		#Imports into java
		execute "keytool import #{ca}" do
			command "#{java_home}/bin/keytool -import -trustcacerts -alias #{ca} -file #{Chef::Config[:file_cache_path]}/#{ca}.cer -keystore #{java_home}/jre/lib/security/cacerts -storepass changeit -noprompt"
			only_if { File.exists?("#{java_home}/bin/keytool") }
			not_if  "#{java_home}/bin/keytool -list -alias #{ca} -keystore #{java_home}/jre/lib/security/cacerts -storepass changeit"
		end	
		
	end
end