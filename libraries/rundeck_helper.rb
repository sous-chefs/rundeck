#!/usr/bin/env ruby
require 'securerandom'

module RundeckHelper

  def self.generateuuid

    return SecureRandom.uuid

  end

end
