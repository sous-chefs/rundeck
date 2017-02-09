include_recipe 'build-essential'

chef_gem 'chef-zero'
chef_gem 'ridley'

execute 'server' do
   cwd '/opt/chef/embedded/'
   command 'bin/chef-zero -H localhost -p 8089 -d'
end

ruby_block 'Add test nodes in chef-zero server' do
  block do
    require 'ridley'

    chef_objects_file = File.join(File.dirname(__FILE__), '..', 'files', 'chef-objects.json')
    chef_objects = JSON.parse(File.read(chef_objects_file))

    begin
      ridley = Ridley.from_chef_config('/etc/chef/rundeck.rb')

      chef_objects['environments'].each { |env| ridley.environment.create env }

      chef_objects['nodes'].each { |node| ridley.node.create node }
    rescue Ridley::Errors::HTTPConflict => err 
      Chef::Log.warn("Ignoring this error as chef-objects are set previously : #{err}")
    end    
  end
end
