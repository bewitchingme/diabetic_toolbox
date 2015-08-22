# TODO: Must implement the mailer here to confirm the member.
module DiabeticToolbox
  # The DiabeticToolbox::Members::CreateMember action is used to
  # create a new member and prepare resulting response data
  # to the caller.
  class CreateMember
    ##
    # SAFE outlines which attributes of the active record model are
    # approved for return to the caller using #safe_model_data
    SAFE = [:first_name, :last_name, :username, :slug]

    ##
    # Construct with the parameters for the member.
    #
    # :call-seq:
    #   new(member_params) => Boolean
    #
    def initialize(member_params)
      @respond_with = I18n.t('flash.member.created.failure')
      @params       = member_params
      @messages     = {}
      @success      = false
      @member       = nil
    end

    ##
    # Initiates the action to create the member.
    #
    # :call-seq:
    #   call() => DiabeticToolbox::Members::CreateMember
    #
    def call
      @member  = Member.new @params

      if @member.save
        @respond_with = I18n.t('flash.member.created.success', first_name: @member.first_name)
        @success      = true
      else
        @messages     = @member.errors.messages
      end

      self
    end

    ##
    # Success boolean
    #
    # :call-seq:
    #   successful?() => Boolean
    #
    def successful?
      @success
    end

    ##
    # A portable response message regarding the
    # result and status of the action in the form:
    #
    # [message => String, validation_messages => Hash, safe_model_data => Hash]
    #
    # :call-seq:
    #   response() => Array
    def response
      [@respond_with, @messages, _safe]
    end

    ##
    # The flash message for the user, same as #response[0]
    #
    # :call-seq:
    #   flash() => String
    #
    def flash
      @respond_with
    end

    ##
    # The DiabeticToolbox::Member ActiveRecord object used
    # to perform this operation.
    #
    # :call-seq:
    #   actual => DiabeticToolbox::Member
    #
    def actual
      @member
    end

    # :enddoc:
    private
      def _safe
        Hash[ SAFE.each.map { |n| [n, @member[n]] } ]
      end
  end
end