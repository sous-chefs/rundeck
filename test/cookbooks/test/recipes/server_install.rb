rundeck_server_install 'package' do
  action [:install]
end

rundeck_apache 'package' do
  action [:install]
end
