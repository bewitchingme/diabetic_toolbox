module DiabeticToolbox
  #:enddoc:
  class ReportConfiguration < ActiveRecord::Base
    belongs_to :member, class_name: 'DiabeticToolbox::Member'
  end
end
