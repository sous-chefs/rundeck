require 'spec_helper'

describe 'rundeck::server' do
  # ordered list of included recipes
  let(:included_recipes) do
    %w(rundeck::_data_bags rundeck::server_dependencies
       rundeck::apache rundeck::server_install
       rundeck::_connect_rundeck_api_client rundeck::_projects)
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
end
