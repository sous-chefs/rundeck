require 'spec_helper'

describe 'rundeck::_projects' do
  cached(:chef_run) do
    ChefSpec::ServerRunner.new(step_into: ['rundeck_project']) do |node, server|
      rundeck_stubs(node, server)
    end.converge(described_recipe)
  end

  it 'includes the correct recipes' do
    %w(rundeck::_data_bags rundeck::_connect_rundeck_api_client).each do |recipe|
      expect(chef_run).to include_recipe(recipe)
    end
  end

  it 'creates projects using the lwrp' do
    expect(chef_run).to run_ruby_block('connect rundeck api client')
    %w(localhost test-project).each do |project_name|
      expect(chef_run).to create_rundeck_project(project_name)
      expect(chef_run).to run_ruby_block("create / update Rundeck project #{project_name}")
    end
  end
end
