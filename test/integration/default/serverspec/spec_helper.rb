require 'serverspec'
load '/tmp/kitchen/cookbooks/rundeck/libraries/rundeck_api_client.rb'

set :backend, :exec

# chkconfig is not on PATH by default. so set it
set :path, '/sbin:/usr/local/sbin:/user/sbin:$PATH'

def regex_exact_match(string)
  Regexp.new('^' + Regexp.escape(string) + '$')
end
