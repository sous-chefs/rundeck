require 'spec_helper'

describe 'rundeck_repository - Ubuntu' do
  step_into :rundeck_project
  platform 'ubuntu'

  context 'create test project' do
    recipe do
      rundeck_project 'test' do
        admin_password 'admin'
        endpoint 'http://localhost:4440'
      end
    end

    it 'installs rest-client' do
      is_expected.to install_chef_gem('rest-client')
    end


  end
end
