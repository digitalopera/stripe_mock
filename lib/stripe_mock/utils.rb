module StripeMock
  def self.new_id(prefix)
    "#{ prefix }_#{ Faker::Internet.password(16) }"
  end

  # Recursively converts all hash values that are string ints into actual ints
  def self.convert_hash_values_to_i(hash)
    hash.each do |k, v|
      if v.is_a?(String)
        hash[k] = convert_string_to_i v

      elsif v.is_a?(Hash)
        hash[k] = convert_hash_values_to_i v

      elsif v.is_a?(Array)
        hash[k] = convert_array_values_to_i v
      end
    end
  end

  # Recursively converts all array hash values that are string ints into actual ints
  def self.convert_array_values_to_i(array)
    array.map do |item|
      if item.is_a?(Hash)
        convert_hash_values_to_i item
      elsif item.is_a?(Array)
        convert_hash_values_to_i item
      elsif item.is_a?(String)
        convert_string_to_i item
      else
        item
      end
    end
  end

  # Converts values that are string ints into actual ints
  def self.convert_string_to_i(value)
    if /\A(?!0+)\d+\z/.match(value) != nil
      value.to_i
    else
      value
    end
  end
end
