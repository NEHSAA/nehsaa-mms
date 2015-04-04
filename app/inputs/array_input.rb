class ArrayInput < SimpleForm::Inputs::StringInput

  def input(wrapper_options)
    input_html_options[:type] ||= input_type
    input_html_options[:name] ||= "#{object_name}[#{attribute_name}][]"
    #input_html_options[:placeholder] ||= I18n.t("allow_blank")
    options[:min_count] ||= 1

    values = Array(object.public_send(attribute_name))
    delta = options[:min_count] - values.count
    values += [''] * delta if delta > 0
    values.each_with_index.map do |value, index|
      h_options = input_html_options.merge value: value
      h_options[:placeholder] = I18n.t("ui.array_input.allow_blank") if index > 0
      merged_options = merge_wrapper_options(h_options, wrapper_options)
      @builder.text_field("#{attribute_name}[#{index}]", merged_options)
    end.join.html_safe
  end

  def input_type
    :text
  end

end
