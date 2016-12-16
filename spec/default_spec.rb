require 'spec_helper'

describe 'rundeck::default' do
  cached(:chef_run) do
    ChefSpec::ServerRunner.new do |node, server|
      rundeck_stubs(node, server)
    end.converge(described_recipe)
  end

  it 'includes rundeck::node_unix' do
    expect(chef_run).to include_recipe('rundeck::node_unix')
  end
end
