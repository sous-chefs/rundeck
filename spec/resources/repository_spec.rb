require 'spec_helper'

describe 'rundeck_repository - Ubuntu' do
  step_into :rundeck_repository
  platform 'ubuntu'

  context 'install default repository' do
    recipe do
      rundeck_repository 'default'
    end

    it 'creates repository' do
      is_expected.to add_apt_repository('rundeck')
    end
  end
end

describe 'rundeck_repository - RedHat' do
  step_into :rundeck_repository
  platform 'redhat'

  context 'install default repository' do
    recipe do
      rundeck_repository 'default'
    end

    it 'creates repository' do
      is_expected.to add_yum_repository('rundeck')
    end
  end
end
