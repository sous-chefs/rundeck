# frozen_string_literal: true

if os[:family] == 'redhat' || os[:family] == 'fedora'
  describe service('rundeckd') do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
  end
else
  describe service('rundeckd') do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
  end
end
