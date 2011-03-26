class String

  def as_phone(seperator = "-")
    return self if self.empty_or_nil?
    stripped = self.strip_phone_formatting
    if stripped.length == 10
      a = stripped.slice(0..2)
      b = stripped.slice(3..5)
      c = stripped.slice(6..10)
      return a + seperator + b + seperator + c
    end
    return stripped
  end

  def strip_phone_formatting
    self.gsub(/\/|\(|\)|-|\.| /, "")
  end

end