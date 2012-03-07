APACHE_VHOST_DIR = '/etc/apache2/vhosts.d/'

def load_current_resource
    @res = Chef::Resource::ApacheFastcgi.new(new_resource)
    @res.name(new_resource.name)
    @res.server_name(new_resource.server_name)
    @res.server_alias(new_resource.server_alias)
    @res.socket(new_resource.socket)
    @res.timeout(new_resource.timeout)
    @res.access_log(new_resource.access_log)
    @res.error_log(new_resource.error_log)
    @res.start_service(new_resource.start_service)
    @res.ssl(new_resource.ssl)
    @res.ssl_cipher_suite(new_resource.ssl_cipher_suite)
    @res.ssl_certificate_file(new_resource.ssl_certificate_file)
    @res.ssl_certificate_key_file(new_resource.ssl_certificate_key_file)
    check_input_params
end


action :install do

 server_name_attr = @res.server_name
 server_alias_attr = @res.server_alias
 socket_attr = @res.socket
 timeout_attr = @res.timeout
 start_service_attr = @res.start_service

 ssl_attr = @res.ssl
 ssl_cipher_suite_attr = @res.ssl_cipher_suite
 ssl_certificate_file_attr = @res.ssl_certificate_file
 ssl_certificate_key_file_attr = @res.ssl_certificate_key_file
 
 access_log_attr = access_log
 error_log_attr = error_log
 virtual_file_attr = virtual_file
 
 service 'apache2'

 
 case node.platform # sorry for this case, but gentoo still not supported in apache2 cookbook
		    # http://tickets.opscode.com/browse/COOK-817
 when 'gentoo'
    template vhost_config_path do
	source 'fast-cgi-vhost.erb'
        variables(
           :params => {
	        :server_name 	=> server_name_attr,
	        :server_alias 	=> server_alias_attr,
                :socket 	=> socket_attr,
		:virtual_file 	=> virtual_file_attr,
    	        :idle_timeout 	=> timeout_attr,
		:access_log 	=> access_log_attr,
        	:error_log 	=> error_log_attr,
        	:ssl       	=> ssl_attr,
        	:ssl_cipher_suite 		=> ssl_cipher_suite_attr,
        	:ssl_certificate_file 		=> ssl_certificate_file_attr,
        	:ssl_certificate_key_file 	=> ssl_certificate_key_file_attr
           }
	)
        cookbook 'apache'
	notifies :restart, resources(:service =>'apache2') if start_service_attr == true
    end
  else 
    web_app vhost_id do # definition goes with apache2 cookbook, see OS supported there ((:
	template 'fast-cgi-vhost.erb'
	cookbook 'apache'
	server_name server_name_attr
        socket socket_attr
	virtual_file virtual_file_attr
        idle_timeout timeout_attr
	access_log access_log_attr
        error_log  error_log_attr
        ssl ssl_attr
        ssl_cipher_suite ssl_cipher_suite_attr
        ssl_certificate_file ssl_certificate_file_attr
        ssl_certificate_key_file ssl_certificate_key_file
    end      
 end
 
  
 new_resource.updated_by_last_action(true)
end


def vhost_config_path
 "#{APACHE_VHOST_DIR}#{vhost_id}.conf"
end

def virtual_file
 "/tmp/#{vhost_id}-application"
end

def access_log
 @res.access_log.nil? ? "#{node.apache.log_dir}/#{vhost_id}-access.log" : @res.access_log
end

def error_log
 @res.error_log.nil? ? "#{node.apache.log_dir}/#{vhost_id}-error.log" : @res.error_log
end

def check_input_params 
 [
  'socket', 'server_name',
 ].each  do |p|
   raise "#{p} - obligatory parameter" if @res.send(p).nil?
 end
end


def vhost_id
 id = @res.name
 id.gsub!(' ','-')
 id.chomp!
 id
end
