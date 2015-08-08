module DiabeticToolbox::Members
  class CreateMember
    ##
    # Construct with the parameters for the member.
    #
    # :call-seq:
    #   new(member_params) => Boolean
    #
    def initialize(member_params)
      @params = member_params
    end

    def call
      @member  = DiabeticToolbox::Member.new @params
      @success = false

      if @member.save
        @respond_with = I18n.t('flash.member.created.success', first_name: @member.first_name)
        @messages     = {}
        @success      = true
      else
        @respond_with = I18n.t('flash.member.created.failure')
        @messages     = @member.errors.messages
      end

      self
    end

    def successful?
      @success
    end

    def response
      [@respond_with, @messages]
    end

    def flash
      @respond_with
    end

    def actual
      @member
    end
  end
end