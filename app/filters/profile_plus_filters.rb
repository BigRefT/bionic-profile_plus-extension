module ProfilePlusFilters

  def phone(value, seperator = "-")
    value.to_s.as_phone(seperator)
  end

end