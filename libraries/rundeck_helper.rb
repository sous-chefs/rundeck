require 'chef'
require 'securerandom'

# Helper module for Rundeck.
module RundeckHelper
  class << self
    def generateuuid
      SecureRandom.uuid
    end

    # backwards compatible defaulting of project config based on data bag contents
    def build_project_config(data_bag_contents, project_name, node)
      default_url = "#{data_bag_contents['chef_rundeck_url'].nil? ? node['rundeck']['chef_rundeck_url'] : data_bag_contents['chef_rundeck_url']}/#{project_name}"
      config = {
        'resources' => {
          'source' => {
            1 => {
              'type' => 'url',
              'config' => {
                'includeServerNode' => true,
                'generateFileAutomatically' => true,
                'url' => default_url,
              },
            },
          },
        },
        'project' => {
          'resources' => {
            'file' => ::File.join(
              node['rundeck']['datadir'],
              'projects',
              project_name,
              'etc/resources.xml'
            ),
          },
        },
      }

      if data_bag_contents['project_settings']
        config = Chef::Mixin::DeepMerge.deep_merge(
          data_bag_contents['project_settings'],
          config
        )
      end

      config
    end
  end
end
