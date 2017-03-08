require 'spec_helper'

describe 'rundeck::_connect_rundeck_api_client' do
  cached(:chef_run) do
    ChefSpec::SoloRunner.converge(described_recipe)
  end

  it 'installs dependencies' do
    expect(chef_run).to include_recipe 'build-essential'
    expect(chef_run).to install_build_essential('install_packages').with(
      compile_time: true
    )
    expect(chef_run).to install_chef_gem('rest-client').with(
      compile_time: true,
      version: '~> 2.0'
    )
  end

  it { expect(chef_run).to run_ruby_block('connect rundeck api client') }
end
