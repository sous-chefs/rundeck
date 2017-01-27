require 'chefspec'
require 'chefspec/berkshelf'
require 'json'
require 'securerandom'
require_relative '../libraries/java_properties'
require_relative '../libraries/rundeck_api_client'
require_relative '../libraries/rundeck_helper'

current_dir = File.dirname(File.expand_path(__FILE__))

Dir[File.join(current_dir, 'support/**/*.rb')].sort.each { |f| require f }

RSpec.configure do |config|
  config.platform = 'redhat'
  config.version = '6.6'
  config.log_level = :error
end

at_exit { ChefSpec::Coverage.report! }
