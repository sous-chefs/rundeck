require 'spec_helper'

describe 'rundeck::default' do
  before do
    allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).and_call_original
    allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('rundeck::node_unix')
  end

  cached(:chef_run) do
    ChefSpec::ServerRunner.new do |node, server|
      rundeck_stubs(node, server)
    end.converge(described_recipe)
  end

  it 'includes rundeck::node_unix' do
    expect_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('rundeck::node_unix')
    chef_run
  end
end
