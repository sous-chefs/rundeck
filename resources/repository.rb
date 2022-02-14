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

unified_mode true

include RundeckCookbook::Helpers

property :package_uri, String, default: lazy {
  if platform_family?('rhel', 'fedora', 'amazon')
    'https://packages.rundeck.com/pagerduty/rundeck/rpm_any/rpm_any/$basearch'
  else # 'debian'
    'https://packages.rundeck.com/pagerduty/rundeck/any/'
  end
}
property :gpgkey, String, default: 'https://packages.rundeck.com/pagerduty/rundeck/gpgkey'

property :debsrc, [true, false], default: true

property :gpgcheck, [true, false], default: false

action :install do
  case node['platform_family']
  when 'rhel', 'amazon', 'fedora'
    yum_repository 'rundeck' do
      description 'Rundeck - Release'
      baseurl new_resource.package_uri
      gpgkey new_resource.gpgkey
      gpgcheck new_resource.gpgcheck
      action :create
    end
  when 'debian'
    package 'apt-transport-https'

    apt_repository 'rundeck' do
      uri new_resource.package_uri
      deb_src new_resource.debsrc
      components %w(any main)
      distribution ''
      key new_resource.gpgkey
      action :add
    end
  end
end

action_class do
  include RundeckCookbook::Helpers
end
