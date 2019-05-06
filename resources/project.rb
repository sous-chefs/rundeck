
#
# Cookbook:: rundeck
# Resource:: project
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

include RundeckCookbook::Helpers
require 'json'

property :name, String, name_property: true
property :label, String
property :description, String
property :executions_disable, [true, false], default: false
property :schedule_disable, [true, false], default: false
property :node_cache_delay, Integer
property :node_cache_enable, [true, false]
property :node_cache_firstLoadSynch, [true, false]
property :job_group_expansion_level, Integer
property :display_motd, %w(none projectList projectHome both)
property :display_readme, %w(none projectList projectHome both)
property :project_properties, Hash, default: {}

action :create do
  if current_resource.nil?
    converge_by "Creating project '#{new_resource.name}'" do
      execute_rd("projects create --project #{new_resource.name}")
    end
  end

  config_file = "#{Chef::Config['file_cache_path']}/#{new_resource.name}_projectconfig.json"
  config_contents = new_resource.project_properties.dup

  # Add project details
  config_contents['project.description'] = new_resource.description                                  unless new_resource.description.nil?
  config_contents['project.label'] = new_resource.label                                              unless new_resource.label.nil?
  config_contents['project.disable.executions'] = new_resource.executions_disable ? 'true' : 'false' unless new_resource.executions_disable.nil?
  config_contents['project.disable.schedule'] = new_resource.schedule_disable ? 'true' : 'false'     unless new_resource.schedule_disable.nil?
  # # User Interface
  config_contents['project.jobs.gui.groupExpandLevel'] = new_resource.job_group_expansion_level      unless new_resource.job_group_expansion_level.nil?

  unless new_resource.display_motd.nil?
    if new_resource.display_motd == 'none'
      execute_rd("projects configure delete --project #{new_resource.name} -- project.gui.motd.display")
    else
      config_contents['project.gui.motd.display'] = case new_resource.display_motd
                                                    when 'projectList' then 'projectList'
                                                    when 'projectHome' then 'projectHome'
                                                    when 'both'        then 'projectList,projectHome'
                                                    end
    end
  end

  unless new_resource.display_readme.nil?
    if new_resource.display_readme == 'none'
      execute_rd("projects configure delete --project #{new_resource.name} -- project.gui.readme.display")
    else
      config_contents['project.gui.readme.display'] = case new_resource.display_readme
                                                      when 'projectList' then 'projectList'
                                                      when 'projectHome' then 'projectHome'
                                                      when 'both'        then 'projectList,projectHome'
                                                      end
    end
  end

  file config_file do
    content config_contents.to_json
    action :create
    notifies :run, 'ruby_block[set project settings]', :immediately
  end

  ruby_block 'set project settings' do
    block do
      options =  "--project #{new_resource.name}"
      options << " --file #{config_file}"
      execute_rd("projects configure update #{options}")
    end
    action :nothing
  end
end

action :delete do
  if current_resource.nil?
    converge_by "Deleting project '#{new_resource.name}'" do
      execute_rd("projects delete --project #{new_resource.name}")
    end
  end
end

load_current_value do
  projects = JSON.parse(execute_rd('projects list'))
  current_value_does_not_exist! unless projects.include? name
end
