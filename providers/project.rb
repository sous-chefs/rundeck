use_inline_resources

action :create do
  new_resource.api_client.tap do |client|
    # Check if project is already on server
    if client.get('projects').select { |p| p['name'] == new_resource.name }.empty?
      # Create the project (with no config, config will be set below)
      converge_by "creating project #{new_resource.name}" do
        client.post('projects', name: new_resource.name)
      end
    end

    # Update project config
    # Creating a project with a POST to /projects creates the project with
    # the config provided _and_ additional default config. Updating the
    # project config with a PUT to /project/[PROJECT]/config does not leave
    # that additional default config. To handle this, always update the
    # project config to exactly what is provided to the lwrp.
    converge_by "updating config for project #{new_resource.name}" do
      client.put(
        ::File.join('project', new_resource.name, 'config'),
        new_resource.config.to_java_properties_hash
      )
    end
  end
end
