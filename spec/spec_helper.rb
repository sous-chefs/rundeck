require 'chefspec'
require 'chefspec/berkshelf'

current_dir = File.dirname(File.expand_path(__FILE__))

Dir[File.join(current_dir, 'support/**/*.rb')].sort.each { |f| require f }

RSpec.configure do |config|
  config.platform = 'redhat'
  config.version = '6.6'
  config.log_level = :error
end

at_exit { ChefSpec::Coverage.report! }
