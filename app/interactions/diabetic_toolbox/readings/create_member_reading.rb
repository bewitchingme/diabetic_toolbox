module DiabeticToolbox
  # = CreateMemberReading
  #
  # This class is used to save a reading recorded by a Member
  # as follows:
  #
  #   result = CreateMemberReading.new(member, reading_params).call
  #
  class CreateMemberReading < Exchange
    #:enddoc:
    #region Init
    def initialize(member, reading_params)
      super reading_params
      @member = member
    end
    #endregion

    #region Hooks
    hook :default do
      @reading = @member.readings.new call_params

      if @reading.save
        success do |option|
          option.subject = @reading
          option.message = I18n.t('flash.reading.created.success')
        end
      else
        failure do |option|
          option.subject = @reading
          option.message = I18n.t('flash.reading.created.failure')
        end
      end
    end
    #endregion
  end
end
