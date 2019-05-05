#
# Cookbook:: rundeck
# Library:: helpers
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
require 'securerandom'

module RundeckCookbook
  module Helpers
    include Chef::Mixin::ShellOut
    def generateuuid
      SecureRandom.uuid
    end

    def execute_rd(command)
      cmd_string = "rd #{command}"
      cmd_options = {
        user: 'rundeck',
        environment: {
          RD_CONF: '/var/lib/rundeck/.rd/rd.conf', # FIXME: Requires absolute path
          RD_FORMAT: 'json',
          RD_COLOR: '0',
        },
      }

      cmd = shell_out(cmd_string, cmd_options)

      if cmd.exitstatus != 0
        Chef::Log.fatal("rd failed executing this statement:\n#{cmd_string}")
        Chef::Log.fatal(cmd.stderr)
        raise 'RD CLI ERROR'
      end
      cmd.stdout
    end
  end
end
