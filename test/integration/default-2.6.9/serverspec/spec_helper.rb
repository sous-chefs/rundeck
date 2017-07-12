require 'busser/rubygems'
require 'serverspec'

Busser::RubyGems.install_gem('chef', '~> 12.12')
Busser::RubyGems.install_gem('rest-client', '~> 2.0')

# loading cookbook libraries in test-kitchen is a bit messy
begin
  # kitchen-vagrant lands cookbooks here
  load '/tmp/kitchen/cookbooks/rundeck/libraries/rundeck_api_client.rb'
rescue LoadError
  # kitchen-dokken lands cookbook here
  load '/opt/kitchen/cookbooks/rundeck/libraries/rundeck_api_client.rb'
end

set :backend, :exec

# chkconfig is not on PATH by default. so set it
set :path, '/sbin:/usr/local/sbin:/user/sbin:$PATH'

def regex_exact_match(string)
  Regexp.new('^' + Regexp.escape(string) + '$')
end
