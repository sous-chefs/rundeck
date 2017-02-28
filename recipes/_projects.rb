include_recipe 'rundeck::_data_bags'

node.run_state['rundeck']['projects'].each do |project_name, data_bag_item_contents|
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
