module DiabeticToolbox
  class StandardFormBuilder < ActionView::Helpers::FormBuilder
    def text_field(label, *args)
      options   = args.extract_options!
      new_class, new_data, new_title = overrides(label, options)
      super( label, *(args << options.merge(class: new_class, data: new_data, title: new_title)) )
    end

    def select(method, choices = nil, options = {}, html_options = {}, &block)
      html_options.merge! class: 'form-control input-sm'
      super( method, choices, options, html_options, &block )
    end

    def password_field(label, *args)
      options = args.extract_options!
      new_class, new_data, new_title = overrides(label, options)
      super( label, *(args << options.merge(class: new_class, data: new_data, title: new_title)) )
    end

    def check_box(label, *args)
      options = args.extract_options!
      new_class, new_data, new_title = overrides(label, options)
      super( label, *(args << options.merge(data: new_data, title: new_title)) )
    end

    def submit(label, *args)
      options = args.extract_options!
      new_class = options[:class] || 'btn btn-default btn-sm'
      super( label, *(args << options.merge(class: new_class)) )
    end

    def label(label, *args)
      options = args.extract_options!
      new_class = options[:class] || 'control-label'
      super( label, *(args << options.merge(class: new_class)) )
    end

    private
    def overrides(label, options)
      new_class = options[:class] || 'form-control input-sm'
      new_data  = options[:data] || { toggle: 'tooltip', placement: 'top' }
      new_title = options[:title] || validation_title(label)

      return *[new_class, new_data, new_title]
    end

    def validation_title(label)
      if has_errors_for?( label ) && errors_for(label).length > 0
        errors_for( label )[0]
      end
    end

    def validation_errors
      @object.errors
    end

    def errors_for(label)
      validation_errors.messages[label]
    end

    def has_errors_for?(label)
      validation_errors.keys.length > 0 && validation_errors.include?( label )
    end
  end
end
