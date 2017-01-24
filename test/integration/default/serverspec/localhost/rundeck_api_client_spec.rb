require 'spec_helper'

describe RundeckApiClient do
  let(:client) do
    described_class.new('http://localhost', 'admin', 'adminpassword')
  end

  it 'correctly reads the rundeck server api version' do
    expect(client.version).to eql(18)
  end
end
