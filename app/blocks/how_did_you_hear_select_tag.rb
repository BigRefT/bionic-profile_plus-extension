class HowDidYouHearSelectTag < Liquid::Tag
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
      raise SyntaxError.new("Syntax Error in 'how_did_you_hear_select' - Valid syntax: how_did_you_hear_select [name]")
    end

    super(tag_name, markup, tokens)
  end

  def render(context)
    @context = context
    found_in_model = error_found = false
    found_value = ""
    form_model = nil
    
    unless @context['form_model'].empty_or_nil?
      form_model = @context['form_model']
      register_key = @context['form_register_key']
      if @context.registers[register_key] # get object
        if @context.registers[register_key].respond_to?(@name.to_sym) # does it have the field
          found_value = @context.registers[register_key].send(@name.to_sym)
          error_found = @context.registers[register_key].errors.invalid?(@name.to_sym)
          found_in_model = true
        end
      end
    end

    if attributes['name'].empty_or_nil?
      if form_model.not_nil? && found_in_model
        value = "#{form_model}[#{@name.underscore}]"
      else
        value = "#{(@context[@name] || @name).to_s.underscore}"
      end
      attributes['name'] = value.empty_or_nil? ? "" : "\"#{value}\""
    end

    if attributes['id'].empty_or_nil?
      if form_model.not_nil? && found_in_model
        value = "#{form_model}_#{@name.underscore}"
      else
        value = "#{(@context[@name] || @name).to_s.underscore}"
      end
      attributes['id'] = value.empty_or_nil? ? "" : "\"#{value}\""
    end

    prompt = "<Select One>"
    if attributes['prompt']
      prompt = parse_attribute(attributes.delete('prompt'))
    end

    html_attributes = ""
    attributes.each do |key, value|
      html_attributes += render_attribute(key, value)
    end

    rvalue = ""
    rvalue += "<div class=\"fieldWithErrors\">" if error_found
    rvalue += "<select#{html_attributes}>"
    rvalue += "<option value=\"\">#{html_escape(prompt)}</option>"

    conditions = ['active = ?', true]
    HowDidYouHear.find(:all, :conditions => conditions).each do |how_did_you_hear|
      selected = " selected=\"selected\"" if found_in_model && how_did_you_hear.id.to_s == found_value.to_s
      rvalue += "<option value=\"#{how_did_you_hear.id}\"#{selected}>#{html_escape(how_did_you_hear.label)}</option>"
    end

    rvalue += "</select>"
    rvalue += "</div>" if error_found

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

  # make a copy of the original so we can cover the case of this tag being in a for loop.
  # In this case the first interation will be fine, but if the tag/block deletes an attribute
  # then the second iteration will be missing that attribute.
  def attributes
    # leave the original alone
    @attributes_copy ||= @attributes.dup
  end
end
Liquid::Template.register_tag('how_did_you_hear_select', HowDidYouHearSelectTag)