require 'securerandom'

# Helper module for Rundeck.
module RundeckHelper
  def self.generateuuid
    SecureRandom.uuid
  end
end
