unless Object.respond_to? :blank
  #
  # Implement blank? method
  #
  class Object
    def blank?
      respond_to?(:empty?) ? empty? : !self
    end
  end
end
