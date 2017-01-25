# allows nested elements to be defined with hash['nested']['element']
class Hash
  def self.recursive
    new { |hash, key| hash[key] = recursive }
  end
end
