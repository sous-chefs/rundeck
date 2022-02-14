rundeck_server_install 'package' do
  acl_policies node['rundeck']['acl_policies']
  action :install
end

rundeck_apache 'package' do
  action :install
end

project_properties = {
  'service.FileCopier.default.provider': 'jsch-scp',
}

rundeck_project 'test' do
  description 'test project'
  label 'my test project'
  display_motd 'none'
  executions_disable false
  project_properties project_properties
  action :create
end

rundeck_project 'shouldnotexist' do
  action :delete
end
