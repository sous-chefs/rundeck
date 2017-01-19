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

describe 'rundeck::server_install' do
  cached(:chef_run) do
    ChefSpec::ServerRunner.new do |node, server|
      rundeck_stubs(node, server)
    end.converge(described_recipe)
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
