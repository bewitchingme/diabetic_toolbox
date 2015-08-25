module DiabeticToolbox
  rely_on :action

  # The DiabeticToolboxs::CreateMember action is used to
  # create a new member and prepare resulting response data
  # to the caller.
  class CreateMember < Action
    ##
    # Construct with the parameters for the member.
    #
    # :call-seq:
    #   new(member_params) => Boolean
    #
    def initialize(member_params)
      super member_params

      @successful = lambda do |option|
        option[:subject] = @member
        option[:message] = I18n.t('flash.member.created.success', first_name: @member.first_name)
      end

      @failed = lambda do |option|
        option[:subject] = @member
        option[:message] = I18n.t('flash.member.created.failure')
      end
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
        success &@successful
      else
        failure &@failed
      end
    end

    def _after_call
      # TODO: Must implement the mailer here to confirm the member.
    end
  end
end