require 'spec_helper'

describe 'rundeck::server_install' do
  # ordered list of included recipes
  let(:included_recipes) do
    %w(rundeck::default rundeck::_data_bags rundeck::_connect_rundeck_api_client
       rundeck::_projects)
  end

  before do
    ## uncomment to load resources from included recipes
    # allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).and_call_original
    included_recipes.each do |recipe|
      allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).with(recipe)
    end
  end

  cached(:chef_run) do
    ChefSpec::ServerRunner.new do |node, server|
      rundeck_stubs(node, server)
    end.converge(described_recipe)
  end

  it 'includes the correct recipes' do
    included_recipes.each do |recipe|
      expect_any_instance_of(Chef::Recipe).to receive(:include_recipe).with(recipe)
    end
    chef_run
  end

  it 'renders framework.properties with correct user' do
    expect(chef_run).to create_template('/etc/rundeck/framework.properties')
    expect(chef_run).to render_file('/etc/rundeck/framework.properties').with_content(
      'framework.ssh.user = rundeck'
    )
  end

  context 'framework.ssh.user specified' do
    cached(:chef_run) do
      ChefSpec::ServerRunner.new do |node, server|
        rundeck_stubs(node, server)
        node.set['rundeck']['framework.ssh.user'] = 'serviceaccount'
      end.converge(described_recipe)
    end

    it 'renders framework.properties with correct user' do
      expect(chef_run).to render_file('/etc/rundeck/framework.properties').with_content(
        'framework.ssh.user = serviceaccount'
      )
    end
  end
end
