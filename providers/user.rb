#
# Cookbook Name:: rundeck
# Provider:: user
#
# Copyright 2012, Peter Crossley
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

action :create do

  # Check user existense in realm.properties
  if ::File.read(::File.join(node['rundeck']['configdir'],'realm.properties')).match(/^#{new_resource.name}: /)
    new_resource.updated_by_last_action(false)
    Chef::Log.info("Rundeck user #{new_resource.name} already exists. Please use :update action instead")
  else
    ruby_block "rundeck-create-user-#{new_resource.name}" do
      block do
        new_resource.updated_by_last_action(true)
        # Append the line to realm.properties
        ::File.open(::File.join(node['rundeck']['configdir'],'realm.properties'), 'a') do |fp|
          fp.puts(create_auth_line(new_resource.name, new_resource.password, new_resource.encryption, new_resource.roles))
        end
        Chef::Log.info("Rundeck user #{new_resource.name} created")
      end
      #notifies :restart, 'service[rundeckd]'
    end
  end

end

action :remove do

  # Check user existense in realm.properties
  unless ::File.read(::File.join(node['rundeck']['configdir'],'realm.properties')).match(/^#{new_resource.name}: /)
    new_resource.updated_by_last_action(false)
  else
    ruby_block "rundeck-remove-user-#{new_resource.name}" do
      block do
        new_resource.updated_by_last_action(true)
        ::File.open(::File.join(node['rundeck']['configdir'],'realm.properties'), 'r') do |fp|
          newcontent = String.new
          while line = fp.readline do
            newcontent << line unless fp.gets.match(/^#{new_resource.name}: /)
          end
        end
        ::File.write(::File.join(node['rundeck']['configdir'],'realm.properties'), newcontent)
        Chef::Log.info("Rundeck user #{new_resource.name} removed")
      end
      #notifies :restart, 'service[rundeckd]'
    end
  end

end

action :update do

  new_auth_line = create_auth_line(new_resource.name, new_resource.password, new_resource.encryption, new_resource.roles)

  unless ::File.read(::File.join(node['rundeck']['configdir'],'realm.properties')).match(/^#{new_auth_line}: $/)
    new_resource.updated_by_last_action(false)
    Chef::Log.info("Rundeck user #{new_resource.name} already up to date")
  else
    ruby_block "rundeck-update-user-#{new_resource.name}" do
      block do
        new_resource.updated_by_last_action(true)
        ::File.open(::File.join(node['rundeck']['configdir'],'realm.properties'), 'r') do |fp|
          newcontent = String.new
          while line = fp.readline do
            newcontent << fp.gets.match(/^#{new_resource.name}: /) ? new_auth_line : line
          end
        end
        ::File.write(::File.join(node['rundeck']['configdir'],'realm.properties'), newcontent)
        Chef::Log.info("Rundeck user #{new_resource.name} updated")
      end
      #notifies :restart, 'service[rundeckd]'
    end
  end

end

def create_auth_line(username, password, encryption, roles)
  case encryption
  when 'crypt'
    pass = 'CRYPT:' + password.crypt('rb')
  when 'md5'
    require 'digest/md5'
    pass = 'MD5:' + Digest::MD5.hexdigest(password)
  when 'plain'
    pass = password
  end
  "#{username}: #{pass},#{roles.join(',')}"
end