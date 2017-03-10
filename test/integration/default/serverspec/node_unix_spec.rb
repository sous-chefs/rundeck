require 'spec_helper'

describe group('rundeck') do
  it { should exist }
end

describe user('rundeck') do
  it { should exist }
  it { should belong_to_group 'rundeck' }
  it { should have_login_shell '/bin/bash' }
end

describe file('/home/rundeck') do
  it { should be_directory }
  it { should be_owned_by 'rundeck' }
  it { should be_grouped_into 'rundeck' }
  it { should be_mode 700 }
end

describe file('/home/rundeck/.ssh/authorized_keys') do
  it { should be_file }
  it { should exist }
  it { should be_owned_by 'rundeck' }
  it { should be_grouped_into 'rundeck' }
  it { should be_mode 600 }
  its(:content) { should match(/\W/) }
end
