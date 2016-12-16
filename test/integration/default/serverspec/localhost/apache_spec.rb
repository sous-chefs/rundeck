require 'spec_helper'

describe 'httpd config and service' do
  if os[:family] == 'redhat'
    let(:httpd_service) { 'httpd' }
  elsif os[:family] == 'ubuntu'
    let(:httpd_service) { 'apache2' }
  end

  it 'manages httpd service and config' do
    expect(file("/etc/#{httpd_service}/ssl/localhost.crt")).to_not be_file

    expect(file("/etc/#{httpd_service}/ssl/localhost.key")).to_not be_file

    expect(file("/etc/#{httpd_service}/ssl/localhost-ca-name.crt")).to_not be_file

    expect(file("/etc/#{httpd_service}/sites-available/rundeck.conf")).to be_mode(644)
    expect(file("/etc/#{httpd_service}/sites-available/rundeck.conf")).to be_file
    expect(file("/etc/#{httpd_service}/sites-available/rundeck.conf")).to be_owned_by('root')
    expect(file("/etc/#{httpd_service}/sites-available/rundeck.conf")).to be_grouped_into('root')

    expect(file("/etc/#{httpd_service}/sites-enabled/rundeck.conf")).to be_symlink

    expect(service(httpd_service)).to be_running
  end
end
