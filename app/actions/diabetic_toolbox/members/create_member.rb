module DiabeticToolbox
  rely_on :action

  class CreateMember < Action
    ##
    # Construct with the parameters for the member.
    #
    # :call-seq:
    #   new(member_params) => Boolean
    #
    def initialize(member_params)
      super member_params
    end

    ##
    # Initiates the action to create the member.
    #
    # :call-seq:
    #   call() => DiabeticToolbox::Result::<Base>
    #
    protected
    def _call
      @member = Member.new @params

      if @member.save
        success do |option|
          option[:subject] = @member
          option[:message] = I18n.t('flash.member.created.success', first_name: @member.first_name)
        end
      else
        failure do |option|
          option[:subject] = @member
          option[:message] = I18n.t('flash.member.created.failure')
        end
      end
    end

    def _after_call
      # TODO: Must implement the mailer here to confirm the member.
    end
  end
end