require 'spec_helper'

describe 'rundeck_server_install - RedHat' do
  step_into :rundeck_server_install
  platform 'redhat'

  context 'installs' do
    recipe do
      rundeck_server_install 'default'
    end

    it 'creates install directory' do
      is_expected.to create_directory('/var/lib/rundeck').with(
        user: 'rundeck',
        group: 'rundeck'
      )
    end

    it 'starts rundeckd service' do
      is_expected.to enable_service('rundeckd')
      is_expected.to start_service('rundeckd')
    end
  end
end
