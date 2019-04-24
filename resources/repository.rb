# frozen_string_literal: true
#
# Cookbook:: rundeck
# Resource:: repository
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include RundeckCookbook::Helpers

property :package_uri, String, default: lazy {
  case node['platform_family']
  when 'rhel'
    'https://dl.bintray.com/rundeck/rundeck-rpm'
  else # 'debian'
    'https://dl.bintray.com/rundeck/rundeck-deb'
  end
}
property :gpgkey, String, default: lazy {
  case node['platform_family']
  when 'rhel'
    'http://rundeck.org/keys/BUILD-GPG-KEY-Rundeck.org.key'
  else # 'debian'
    'https://bintray.com/user/downloadSubjectPublicKey?username=bintray'
  end
}
property :gpgcheck, [true, false], default: true

action :install do
  case node['platform_family']
  when 'rhel'
    yum_repository 'rundeck' do
      description 'Rundeck - Release'
      url new_resource.package_uri
      gpgkey new_resource.gpgkey
      gpgcheck new_resource.gpgcheck
      action :add
    end
  when 'debian'
    package 'apt-transport-https'

    apt_repository 'rundeck' do
      uri new_resource.package_uri
      distribution '/'
      key new_resource.gpgkey
      action :add
    end
  end
end

action_class do
  include RundeckCookbook::Helpers
end
