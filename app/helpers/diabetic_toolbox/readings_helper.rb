module DiabeticToolbox
  #:enddoc:
  module ReadingsHelper
    def meal_options
      options_for_select DiabeticToolbox::Reading.meal_options
    end
  end
end
