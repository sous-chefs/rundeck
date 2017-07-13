class Hash
  def to_java_properties_hash(prefix = '')
    properties = {}

    each do |property, value|
      new_prefix = prefix.empty? ? property.to_s : prefix + '.' + property.to_s
      if value.respond_to? :to_java_properties_hash
        properties.merge!(value.to_java_properties_hash(new_prefix))
      else
        properties[new_prefix] = value.to_s
      end
    end

    # return the sorted hash
    Hash[properties.sort_by { |k, _v| k.to_s }]
  end

  def to_java_properties_lines
    lines = []

    to_java_properties_hash.each do |k, v|
      # escape '=', ':', and "\n" with a backslash
      lines << "#{k.gsub(/([=:\n])/, '\\\\\1')}=#{v.gsub(/([=:\n])/, '\\\\\1')}"
    end

    lines
  end

  def to_java_properties_string
    to_java_properties_lines.join("\n")
  end
end
