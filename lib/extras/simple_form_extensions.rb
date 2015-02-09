module ButtonComponents
  def submit_button(*args, &block)
    options = args.extract_options!
    # This was breaking the contact form - better to leave commented for now
    # if object.new_record?
    #   loading = I18n.t('simple_form.creating')
    # else
    #   loading = I18n.t('simple_form.updating')
    # end
    # options[:"data-loading-text"] =
    # [loading, options[:"data-loading-text"]].compact
    options[:class] = ['btn-primary', options[:class]].compact
    args << options
    # rubocop:disable AssignmentInCondition
    if cancel = options.delete(:cancel)
      template.content_tag :div, class: 'col-sm-offset-2' do
        submit(*args, &block) + ' ' + template.link_to(
        template.button_tag(I18n.t('simple_form.buttons.cancel'),
                            type: 'button', class: 'btn btn-default'), cancel)
      end
    else
      submit(*args, &block)
    end
    # rubocop:enable AssignmentInCondition
  end
end

SimpleForm::FormBuilder.send :include, ButtonComponents
