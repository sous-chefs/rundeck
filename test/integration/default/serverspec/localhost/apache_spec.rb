require 'spec_helper'

describe file('/etc/apache2/ssl/localhost.crt') do
  it { should_not exist }
end

describe file('/etc/apache2/ssl/localhost.key') do
  it { should_not be_file }
end

describe file('/etc/apache2/ssl/localhost-ca-name.crt') do
  context "when node['rundeck']['cert']['ca_name'] attribute is not provided" do
    it { should_not exist }
  end
end

describe file('/etc/apache2/sites-available/rundeck.conf') do
  it { should exist }
  it { should be_mode 644 }
  it { should be_file }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
end

describe service('apache2') do
  it { should be_running }
end
