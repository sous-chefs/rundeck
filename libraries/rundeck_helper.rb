require 'securerandom'
require 'chef_zero/server'

# Helper module for Rundeck.
module RundeckHelper
  def self.generateuuid
    SecureRandom.uuid
  end
end
