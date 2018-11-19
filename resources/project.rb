# frozen_string_literal: true
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

property :projects, Hash, default: {}

action :create do
  new_resource.projects.each do |project_name, data_bag_item_contents|
    rundeck_project project_name do
      api_client lazy { node.run_state['rundeck']['api_client'] }
      if data_bag_item_contents['old_style']
        # Create projects with config that was previously applied to all projects
        config RundeckHelper.build_project_config(data_bag_item_contents, project_name, node)
      else
        config data_bag_item_contents['project_settings'] || {}
      end
    end
  end
end
