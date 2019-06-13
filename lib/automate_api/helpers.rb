class Array
  def extract_options!()
    if last.is_a?(Hash) && last.extractable_options?
      Hashie::Mash.new(pop)
    else
      Hashie::Mash.new
    end
  end

  def collectable?(field)
    false
  end
end

class Hash
  def extractable_options?
    instance_of?(Hash)
  end

  def collectable?(field)
    !field.nil? && has_key?(field)
  end
end

class AutomateApi::Mash < Hashie::Mash
  disable_warnings
end
