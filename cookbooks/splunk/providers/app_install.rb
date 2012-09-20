# Copyright 2011-2012, BBY Solutions, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
def initialize(*args)
  super
  @action = :create_if_missing
end

action :create_if_missing do
    app_version = @new_resource.app_version
    app_file = @new_resource.app_file
    required_dependencies = @new_resource.required_dependencies
    local_templates = @new_resource.local_templates
    local_templates_directory = @new_resource.local_templates_directory
    remove_dir = @new_resource.remove_dir_on_upgrade
    
    if node.run_list.roles.include?(node['splunk']['server_role'])
      splunk_dir = node['splunk']['server_home']
    else
      splunk_dir = node['splunk']['forwarder_home']
    end
    
    directory_name = app_file.split(".")[0]
    version_file = "#{splunk_dir}/#{directory_name}.app.#{app_version}"
   
    install_required_dependencies(required_dependencies)
    
    install_or_upgrade(app_file, app_version, directory_name, version_file, splunk_dir, remove_dir)
    
    move_local_templates(local_templates, local_templates_directory, directory_name, splunk_dir)
    new_resource.updated_by_last_action(true)
end

private

def install_required_dependencies(required_dependencies)
  if !required_dependencies.nil?
      required_dependencies.each do |pkg|
        package pkg do
          action :install
        end
      end
  end
end

def install_or_upgrade(app_file, app_version, directory_name, version_file, splunk_dir, remove_dir)
   
    if ::File.exists?(version_file) == false

      if ::File.directory?("#{splunk_dir}/etc/apps/#{directory_name}") == true

        execute "#{splunk_dir}/bin/splunk stop" do
          returns [0,1]
        end

        if remove_dir == "true"
          execute "rm -rf #{splunk_dir}/etc/apps/#{directory_name}/*"
        end
      end

      cookbook_file "#{splunk_dir}/etc/apps/#{app_file}" do
        source "apps/#{app_file}"
      end

      execute "cd #{splunk_dir}/etc/apps; tar -zxvf #{app_file}" do
        notifies :restart, resources(:service => "splunk")
      end

      directory "#{splunk_dir}/etc/apps/#{directory_name}/local" do
        owner "root"
        group "root"
      end

      file version_file do
        content app_version
      end
    end
    
end

def move_local_templates(local_templates, local_templates_directory, directory_name, splunk_dir)
  if !local_templates.nil? && !local_templates_directory.nil?
    local_templates.each do |templ|
       
       template "#{splunk_dir}/etc/apps/#{directory_name}/local/#{templ.split(".erb")[0]}" do
        	source "apps/#{local_templates_directory}/#{templ}"
        	owner "root"
        	group "root"
        	mode "0640"
        	notifies :restart, resources(:service => "splunk")
       end
       
    end
  end
end

