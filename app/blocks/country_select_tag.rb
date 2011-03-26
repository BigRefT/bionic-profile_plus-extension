class CountrySelectTag < Liquid::Tag
  include ERB::Util

  Syntax = /([\w\.]+)/
  # <length:##> <class:form_class> <id:form_id>
  def initialize(tag_name, markup, tokens)
    if markup =~ Syntax
      @name = $1
      @attributes = {}
      markup.scan(Liquid::TagAttributes) do |key, value|
        @attributes[key] = value
      end
    else
      raise SyntaxError.new("Syntax Error in 'country_select' - Valid syntax: country_select [name]")
    end

    super(tag_name, markup, tokens)
  end

  def render(context)
    @context = context
    init_form_options
    load_form_optons
    massage_html_attributes
    load_options

    rvalue = options[:no_javascript] ? '' : country_province_javascript
    rvalue += "<div class=\"fieldWithErrors\">\n" if form_options[:error_found]
    rvalue += "<select#{render_attributes} onchange=\"countrySelected('#{parse_attribute(attributes['id'])}', '#{parse_attribute(options[:province_id])}', #{options[:province_label_prefix] || "''"}, #{options[:province_label_suffix] || "''"})\">\n"

    rvalue += "<option value=\"\">#{html_escape(options[:prompt])}</option>\n" if options[:include_blank]
    site_countries.each do |site_country|
      if (form_options[:found_in_model] && site_country.id.to_s == form_options[:found_value].to_s) ||
         (form_options[:found_in_model] && form_options[:found_value].empty_or_nil? && site_country.country.code == options[:default_code])
        selected = " selected=\"selected\""
      end
      rvalue += "<option value=\"#{site_country.id}\"#{selected}>#{html_escape(site_country.country.name)}</option>\n"
    end

    rvalue += "</select>\n"
    rvalue += "</div>\n" if form_options[:error_found]
    
    rvalue += "<script type=\"text/javascript\">\n"
    rvalue += "document.observe('dom:loaded', function() {\n"
    rvalue += "  countrySelected('#{parse_attribute(attributes['id'])}', '#{parse_attribute(options[:province_id])}', #{options[:province_label_prefix] || "''"}, #{options[:province_label_suffix] || "''"});\n"
    rvalue += "});\n"
    rvalue += "</script>\n"

    # clear the attribute_copy so the next
    # pass will get a fresh copy from the original
    @attributes_copy = nil
    # return rendered value
    rvalue
  end

  private

  def render_attribute(key, value)
    " #{key}=\"#{html_escape(parse_attribute(value))}\""
  end

  def parse_attribute(value)
    if value =~ Bionic::QuotedAttribute
      $1 || $2
    else
      context_value(value)
    end
  end

  def context_value(value)
    @context[value] || value
  end

  def render_attributes
    html_attributes = ""
    attributes.each do |key, value|
      html_attributes += render_attribute(key, value)
    end
    html_attributes
  end

  def country_province_javascript
    rvalue = province_javascript_array
    rvalue += country_selected_javascript
    rvalue
  end

  def site_countries
    @site_countries ||= SiteCountry.all
  end

  def site_provinces
    @site_provinces ||= SiteProvince.active.find(:all, :conditions => ["site_country_id in (?)", site_countries.map { |sc| sc.id }])
  end

  def province_javascript_array
    rvalue = "<script type=\"text/javascript\">\n"
    rvalue += "var states = new Array();\n"
    site_provinces.each do |site_province|
      rvalue += "states.push(new Array(#{site_province.site_country_id}, '#{site_province.name}', #{site_province.id}, '#{site_province.province.country.province_title.singularize}'));\n"
    end
    rvalue
  end

  def country_selected_javascript
    rvalue = "function countrySelected(country_select_id, province_select_id, province_label_prefix, province_label_suffix) {\n"
    rvalue += "  site_country_id = $(country_select_id).getValue();\n"
    rvalue += "  province_label = Form.Label.getFor(province_select_id);\n"
    rvalue += "  province_select = $(province_select_id);\n"
    rvalue += "  province_label_text = 'State/Province';\n"
    rvalue += "  selected_province = province_select.options[province_select.selectedIndex].value;\n"
    rvalue += "  options = province_select.options;\n"
    rvalue += "  options.length = 1;\n"
    rvalue += "  states.each(function(state) {\n"
    rvalue += "    if (state[0] == site_country_id) {\n"
    rvalue += "      new_option = new Option(state[1], state[2]);\n"
    rvalue += "      if (state[2] == selected_province) new_option.selected = true;\n"
    rvalue += "      options[options.length] = new_option;\n"
    rvalue += "      province_label_text = state[3];\n"
    rvalue += "    }\n"
    rvalue += "  });\n"
    rvalue += "  province_label.update(province_label_prefix + province_label_text + province_label_suffix);\n"
    rvalue += "}\n"
    rvalue += "</script>\n"
    rvalue
  end

  def form_options
    @form_options
  end

  def init_form_options
    @form_options = {
      :found_in_model => false,
      :error_found => false,
      :found_value => "",
      :form_model => nil
    }
  end

  def load_form_optons
    unless @context['form_model'].empty_or_nil?
      form_options[:form_model] = @context['form_model']
      register_key = @context['form_register_key']
      if @context.registers[register_key] # get object
        if @context.registers[register_key].respond_to?(@name.to_sym) # does it have the field
          form_options[:found_value] = @context.registers[register_key].send(@name.to_sym)
          form_options[:error_found] = @context.registers[register_key].errors.invalid?(@name.to_sym)
          form_options[:found_in_model] = true
        end
      end
    end
  end

  def massage_html_attributes
    if attributes['name'].empty_or_nil?
      if form_options[:form_model].not_nil? && form_options[:found_in_model]
        value = "#{form_options[:form_model]}[#{@name.underscore}]"
      else
        value = "#{(@context[@name] || @name).to_s.underscore}"
      end
      attributes['name'] = value.empty_or_nil? ? "" : "\"#{value}\""
    end

    if attributes['id'].empty_or_nil?
      if form_options[:form_model].not_nil? && form_options[:found_in_model]
        value = "#{form_options[:form_model]}_#{@name.underscore}"
      else
        value = "#{(@context[@name] || @name).to_s.underscore}"
      end
      attributes['id'] = value.empty_or_nil? ? "" : "\"#{value}\""
    end
  end

  def load_options
    @options = {}
    options[:default_code] = attributes.delete('default_code')

    no_javascript = attributes.delete('no_javascript')
    options[:no_javascript] = ['yes', 'true', '1'].include?(no_javascript)

    include_blank = attributes.delete('include_blank')
    options[:include_blank] = ['yes', 'true', '1'].include?(include_blank)

    options[:province_id] = attributes.delete('province_id')
    options[:province_id] ||= attributes['id'].gsub('country', 'province')

    options[:province_label_prefix] = attributes.delete('province_label_prefix')
    options[:province_label_suffix] = attributes.delete('province_label_suffix')

    options[:prompt] = "<Select One>"
    if attributes['prompt']
      options[:prompt] = parse_attribute(attributes.delete('prompt'))
    end
  end

  def options
    @options
  end

  # make a copy of the original so we can cover the case of this tag being in a for loop.
  # In this case the first interation will be fine, but if the tag/block deletes an attribute
  # then the second iteration will be missing that attribute.
  def attributes
    # leave the original alone
    @attributes_copy ||= @attributes.dup
  end
end
Liquid::Template.register_tag('country_select', CountrySelectTag)