require 'spec_helper'

describe 'rundeck::_projects' do
  cached(:chef_run) do
    ChefSpec::ServerRunner.new(step_into: ['rundeck_project']) do |node, server|
      rundeck_stubs(node, server)
    end.converge(described_recipe)
  end

  it 'includes the data bag recipe' do
    expect(chef_run).to include_recipe('rundeck::_data_bags')
  end

  it 'creates projects using the lwrp' do
    %w(localhost test-project).each do |project_name|
      expect(chef_run).to create_rundeck_project(project_name)
      expect(chef_run).to run_ruby_block("create / update Rundeck project #{project_name}")
    end
  end
end
