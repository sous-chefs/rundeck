require 'spec_helper'

describe RundeckHelper do
  describe '#generateuuid' do
    let(:uuid) { 'c5f54c42-7444-4a9e-8bd8-ccd29650b2ad' }

    it 'returns a uuid from securerandom' do
      allow(SecureRandom).to receive(:uuid).and_return(uuid)
      expect(described_class.generateuuid).to eql(uuid)
    end
  end

  describe '#build_project_config' do
    let(:data_bag_contents) do
      { 'id' => 'test-project',
        'description' => 'Test project.',
        'project_settings' =>
        { 'project' =>
          { 'ssh-keypath' => '/var/lib/rundeck/.ssh/id_rsa',
            'ssh-authentication' => 'password',
            'ssh.user' => 'svcacct',
            'ssh-password-storage-path' => 'keys/svcacct.password',
            'sudo-command-enabled' => 'true',
            'sudo-password-storage-path' => 'keys/svcacct.password' } } }
    end
    let(:project_name) { 'test-project' }
    let(:node) do
      {
        'rundeck' => {
          'chef_rundeck_url' => 'http://chef.rundeck:1234/url',
          'datadir' => '/rundeck/datadir/',
        },
      }
    end

    it 'builds a project config hash from data bag contents' do
      expect(
        described_class.build_project_config(data_bag_contents, project_name, node)
      ).to eql(
        'project' => {
          'resources' => {
            'file' => '/rundeck/datadir/projects/test-project/etc/resources.xml',
          },
          'ssh-authentication' => 'password',
          'ssh-keypath' => '/var/lib/rundeck/.ssh/id_rsa',
          'ssh-password-storage-path' => 'keys/svcacct.password',
          'ssh.user' => 'svcacct',
          'sudo-command-enabled' => 'true',
          'sudo-password-storage-path' => 'keys/svcacct.password',
        },
        'resources' => {
          'source' => {
            1 => {
              'type' => 'url',
              'config' => {
                'includeServerNode' => true,
                'generateFileAutomatically' => true,
                'url' => 'http://chef.rundeck:1234/url/test-project',
              },
            },
          },
        }
      )
    end
  end
end
