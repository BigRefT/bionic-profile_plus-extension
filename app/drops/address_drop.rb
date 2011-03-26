class AddressDrop < Liquid::Drop

  def initialize(address)
    @address = address
  end
  
  def name
    @address.name
  end

  def first_name
    @address.first_name
  end

  def last_name
    @address.last_name
  end

  def label
    @address.label
  end

  def address_line_1
    @address.address_line_1
  end

  def address_line_2
    @address.address_line_2
  end

  def city
    @address.city
  end

  def province_name
    @address.province_name
  end

  def province_code
    @address.province_code
  end

  def country_name
    @address.country_name
  end

  def country_code
    @address.country_code
  end

  def postal_code
    @address.postal_code
  end
  
  def id
    @address.id
  end
  
  def delete_url
    "/forms/address/delete/#{id}"
  end
  
  def formatted_display
    return %{
      <div id="formatted_address_#{id}" class="formatted_address">
        <ul>
          <li id="address_label">#{label}</li>
          <li id="address_name">#{name}</li>
          <li id="address_line_1">#{address_line_1}</li>
          <li id="address_line_2">#{address_line_2}</li>
          <li id="address_local">#{city}, #{province_name} #{postal_code}</li>
        </ul>
      </div>
    }
  end

end