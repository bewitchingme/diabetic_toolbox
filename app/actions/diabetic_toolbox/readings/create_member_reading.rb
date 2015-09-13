module DiabeticToolbox
  rely_on :action

  class CreateMemberReading < Action
    #region Init
    def initialize(member, reading_params)
      super reading_params
      @member = member
    end
    #endregion

    #region Protected
    def _call
      @reading = @member.readings.new @params

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
