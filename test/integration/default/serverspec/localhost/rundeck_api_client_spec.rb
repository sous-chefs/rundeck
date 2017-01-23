require 'spec_helper'

describe RundeckApiClient do
  let(:client) do
    client = described_class.new('http://localhost', 'admin')
    client.authenticate('adminpassword')
    client
  end

  it 'correctly reads the rundeck server api version' do
    expect(client.version).to eql(18)
  end
end
