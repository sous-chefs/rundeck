node.run_state['rundeck']['projects'].each do |project_name,data_bag_item_contents|
  ruby_block "create / update #{project_name}" do
    notifies :run, 'ruby_block[connect rundeck api client]', :before
    block do
      node.run_state['rundeck']['api_client']
    end
  end
end

data_bag(node['rundeck']['rundeck_projects_databag']).each do |project|
  config = data_bag_item(node['rundeck']['rundeck_projects_databag'], project)

  custom = ''
  unless pdata['project_settings'].nil?
    pdata['project_settings'].map do |key, val|
      custom += " --#{key}=#{val}"
    end
  end

  cmd = <<-EOH.to_s
  rd-project -p #{project} -a create \
  --resources.source.1.type=url \
  --resources.source.1.config.includeServerNode=true \
  --resources.source.1.config.generateFileAutomatically=true \
  --resources.source.1.config.url=#{pdata['chef_rundeck_url'].nil? ? node['rundeck']['chef_rundeck_url'] : pdata['chef_rundeck_url']}/#{project} \
  --project.resources.file=#{node['rundeck']['datadir']}/projects/#{project}/etc/resources.xml #{custom}
  EOH

  bash "check-project-#{project}" do
    user node['rundeck']['user']
    code cmd.strip
    # will return 0 if grep matches
    # only run if project does not exist
    only_if "rd-jobs -p #{project} list 2>&1 | grep -q '^ERROR .*project does not exist'"

    retries 5
    retry_delay 15
  end
end
