require 'spec_helper'

describe RundeckApiClient do
  let(:client) do
    described_class.connect('http://localhost', 'admin', 'adminpassword')
  end

  let(:project_def) do
    {
      name: 'kitchen-api-proj',
      description: 'Created via api by test-kitchen',
      config: { a: 'A', b: 'B' }
    }
  end

  it 'connects to the api' do
    expect(client).to be_an_instance_of(described_class)
  end

  it 'retrieves the api version' do
    expect(client.version).to eql(18)
  end

  it 'manages projects' do
    client.post('projects', project_def)
    expect { client.post('projects', project_def) }.to raise_error(RestClient::Conflict)

    project = client.get('projects').select { |p| p['name'] == project_def[:name] }.first
    expect(client.get(project['url'])['config']).to include({ 'a' => 'A', 'b' => 'B' })

    client.delete(project['url'])
  end
end
