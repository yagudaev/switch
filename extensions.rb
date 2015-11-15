module Enumerable
  # flatten a nested hash using a dot notation for the keys
  # http://stackoverflow.com/questions/10712679/flatten-a-nested-json-object
  def flatten_with_path(parent_prefix = nil)
    res = {}

    self.each_with_index do |elem, i|
      if elem.is_a?(Array)
        k, v = elem
        # support for multiline strings in json, maybe we need a parameter here? on/off?
        if v.is_a?(Array) && v.all? {|c| c.is_a?(String)}
          v = v.join("\n")
        end
      else
        k, v = i, elem
      end

      key = parent_prefix ? "#{parent_prefix}.#{k}" : k # assign key name for result hash

      if v.is_a? Enumerable
        res.merge!(v.flatten_with_path(key)) # recursive call to flatten child elements
      else
        res[key] = v
      end
    end

    res
  end
end
