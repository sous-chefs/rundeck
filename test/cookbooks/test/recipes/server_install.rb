rundeck_server_install 'package' do
  acl_policies node['rundeck']['acl_policies']
  action [:install]
end
