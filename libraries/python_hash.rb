module Extensions
  module Templates
    def python_hash_string(ruby_hash)
      res = "{"
      res << ruby_hash.map do |key, value|
        python_value = case value
        when String
          "'#{value}'"
        when Numeric
          "#{value}"
        when Hash
          python_hash_string value
        end
        "'#{key}': #{python_value}"
      end.join(",\n")
      res << "}"
      res
    end
  end
end
