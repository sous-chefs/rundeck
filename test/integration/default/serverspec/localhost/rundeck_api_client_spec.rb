require 'spec_helper'

describe RundeckApiClient do
  let(:client) do
    described_class.connect('http://localhost', 'admin', 'adminpassword')
  end

  # There's a bug with the current project implementation. Projects are not
  # created on the first chef-client run, there are 0 projects until the second
  # chef-client converges. This should be incremented to 1 once this bug is
  # resolved and projects are being created by the first chef-client.
  #
  # https://github.com/Webtrends/rundeck/issues/136
  let(:initial_project_count) { 0 }
  let(:project_create_hash) do
    { name: 'test-proj', config: { a: 'A', b: 'B' } }
  end
  let(:project) do
    {
      'url' => 'http://localhost/api/18/project/test-proj',
      'name' => 'test-proj',
      'description' => ''
    }
  end

  it 'correctly reads the rundeck server api version' do
    expect(client.version).to eql(18)
  end

  it 'manages projects' do
    expect(client.get('projects').length).to eql(initial_project_count)

    client.post('projects', project_create_hash)
    expect(client.get('projects').length).to eql(initial_project_count + 1)
    expect(client.get('projects')).to include(project)

    client.delete(project['url'])
    expect(client.get('projects').length).to eql(initial_project_count)
    expect(client.get('projects')).to_not include(project)

    3.times do
      client.post_or_put('projects', project_create_hash)
      expect(client.get('projects').length).to eql(initial_project_count + 1)
      expect(client.get('projects')).to include(project)
    end

    client.delete(project['url'])
    expect(client.get('projects').length).to eql(initial_project_count)
    expect(client.get('projects')).to_not include(project)
  end
end
