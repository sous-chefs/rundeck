require 'spec_helper'

describe 'rundeck::_projects' do
  cached(:chef_run) do
    ChefSpec::ServerRunner.new do |node, server|
      rundeck_stubs(node, server)
    end.converge(described_recipe)
  end

  it 'includes the correct recipes' do
    %w(rundeck::_data_bags rundeck::_connect_rundeck_api_client).each do |recipe|
      expect(chef_run).to include_recipe(recipe)
    end
  end

  it 'creates projects using the lwrp' do
    expect(chef_run).to create_rundeck_project('localhost')
    expect(chef_run).to create_rundeck_project('test-project')
  end
end
