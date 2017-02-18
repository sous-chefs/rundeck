# rest-client gem is needed for api client library
# install at compile time so library can be used as soon as needed
build_essential 'install_packages' do
  compile_time true
end
chef_gem 'rest-client' do
  compile_time true
  version '~> 2.0'
end

# Notify this resource :before using the api client. Client cannot be connected
# until Rundeck server (and proxy if configured) is responding, and api user
# is created.
ruby_block 'connect rundeck api client' do
  action :nothing
  block do
    unless node.run_state['rundeck']['api_client'].respond_to? :get
      admin_user = node['rundeck']['admin_user']
      node.run_state['rundeck']['api_client'] = RundeckApiClient.connect(
        ::File.join(node['rundeck']['grails_server_url'], node['rundeck']['webcontext']),
        admin_user,
        node.run_state['rundeck']['data_bag']['users']['users'][admin_user]['password'],
        node['rundeck']['api_client_config'] || {}
      )
    end
  end
end
