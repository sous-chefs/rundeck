require 'chefspec'
require 'chefspec/berkshelf'
require 'json'
require 'securerandom'
require 'yaml'
require 'xmlsimple'

current_dir = File.dirname(File.expand_path(__FILE__))

Dir[File.join(File.dirname(current_dir), 'libraries/**/*.rb')].sort.each { |f| require f }
Dir[File.join(current_dir, 'support/**/*.rb')].sort.each { |f| require f }

RSpec.configure do |config|
  config.platform = 'centos'
  config.version = '6.9'
  config.log_level = :error
end
