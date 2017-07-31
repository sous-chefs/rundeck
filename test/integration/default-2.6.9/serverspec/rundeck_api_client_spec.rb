require 'spec_helper'

describe RundeckApiClient do
  let(:client) do
    described_class.connect('http://localhost', 'admin', 'adminpassword')
  end

  let(:project_def) do
    {
      name: 'kitchen-api-proj',
      description: 'Created via api by test-kitchen',
      config: { a: 'A', b: 'B' },
    }
  end

  it 'connects to the api' do
    expect(client).to be_an_instance_of(described_class)
  end

  it 'retrieves the api version' do
    expect(client.version).to eql(17)
  end

  it 'creates and configures projects from data bag definitions' do
    expect(client.get('projects')).to eq(
      [{ 'url' => 'http://localhost/api/17/project/localhost',
         'name' => 'localhost',
         'description' => '' },
       { 'url' => 'http://localhost/api/17/project/test-project',
         'name' => 'test-project',
         'description' => '' }]
    )
    expect(client.get('project/localhost/config')).to eq(
      'project.name' => 'localhost',
      'project.resources.file' => '/var/rundeck/projects/localhost/etc/resources.xml',
      'resources.source.1.config.generateFileAutomatically' => 'true',
      'resources.source.1.config.includeServerNode' => 'true',
      'resources.source.1.config.url' => 'http://chef.kitchentest:9980/localhost',
      'resources.source.1.type' => 'url'
    )
    expect(client.get('project/test-project/config')).to eq(
      'a.b' => 'B',
      'a.c.d' => 'true',
      'project.name' => 'test-project'
    )
  end

  it 'creates, updates, and deletes projects' do
    client.post('projects', project_def)
    expect { client.post('projects', project_def) }.to raise_error(RestClient::Conflict)

    project = client.get('projects').select { |p| p['name'] == project_def[:name] }.first
    expect(client.get(project['url'])['config']).to include('a' => 'A', 'b' => 'B')

    client.delete(project['url'])
  end
end
