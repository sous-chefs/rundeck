require 'spec_helper'

describe 'rundeck_install' do
  step_into :rundeck_install
  platform 'ubuntu'

  context 'install rundeck' do
    recipe do
      rundeck_server_install 'package'
    end

    # it { is_expected.to install_package('rundeck') }
  end
end
