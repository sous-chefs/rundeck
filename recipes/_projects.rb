include_recipe 'rundeck::_data_bags'
include_recipe 'rundeck::_connect_rundeck_api_client'

node.run_state['rundeck']['projects'].each do |project_name, data_bag_item_contents|
  rundeck_project project_name do
    config RundeckHelper.build_project_config(data_bag_item_contents, project_name, node)
  end
end
