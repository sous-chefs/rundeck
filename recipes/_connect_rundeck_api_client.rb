# rest-client gem is needed for api client library
# install at compile time so library can be used as soon as needed
include_recipe 'build-essential'
chef_gem 'rest-client' do
  compile_time true
  version '~> 2.0'
end

# Client cannot be connected until Rundeck server (and proxy if configured) is
# responding and api user is created.
ruby_block 'connect rundeck api client' do
  block do
    admin_user = node['rundeck']['admin_user']
    node.run_state['rundeck']['api_client'] = RundeckApiClient.connect(
      ::File.join(node['rundeck']['grails_server_url'], node['rundeck']['webcontext']),
      admin_user,
      node.run_state['rundeck']['data_bag']['users']['users'][admin_user]['password'],
      node['rundeck']['api_client_config'] || {}
    )
  end
end
