module DiabeticToolbox
  # = Result
  #
  # This module is used to spawn either a success or failure result object
  # specifically with respect to interactions with ActiveRecord models.  They
  # are configured with an object of the model itself (the subject) and
  # a message (intended to be used as a flash message.)  An example:
  #
  #   @user = User.new params
  #   if @user.save
  #     result = Result.success do |option|
  #       option.subject = @user
  #       option.message = 'User Saved'
  #     end
  #   end
  #
  # The process for creating a Failure result would be, similarly:
  #
  #   @user = User.new params
  #   if @user.save
  #     result = Result.success do |option|
  #       option.subject = @user
  #       option.message = 'User Saved'
  #     end
  #   else
  #     result = Result.failure do |option|
  #       option.subject = @user
  #       option.message = 'Error!'
  #     end
  #   end
  #
  # In the case that it is unsafe to provide any of the data from
  # the model in the response, you may specify that is not safe
  # to do so:
  #
  #   result = Result.failure do |option|
  #     option.subject = @user
  #     option.message = 'You are not allowed to do this.'
  #     option.unsafe!
  #   end
  #
  # This will ensure that model data is not included in
  # +result.response+
  #
  # == Public Methods
  #
  #   result.success? # False if result was constructed with Result.failure,
  #                   # true otherwise.
  #   result.flash    # Intended as a flash message for the user, a high-level
  #                   # message intended for overall status of the interaction.
  #   result.response # An array in the format of [flash_message, error_messages, safe_data]
  #   result.actual   # The model as set for +option.subject+ subject.
  #
  module Result
    # :enddoc:
    #region Options
    class Options
      attr_accessor :subject, :message, :security_risk
      @security_risk = false

      def unsafe!
        @security_risk = true
      end

      def unsafe?
        @security_risk
      end
    end
    private_constant :Options
    #endregion

    #region Base
    class Base
      #region New
      def initialize
        @options         = Options.new
        @options.subject = nil
        @options.message = I18n.t('diabetic_toolbox.result.blank')

        if block_given?
          yield @options
        end

        @messages = validation_errors
      end
      #endregion

      #region Public
      def success?
        @success
      end

      def flash
        @options.message
      end

      def response
        [flash, @messages, _safe]
      end

      def actual
        @options.subject
      end
      #endregion

      #region Protected
      protected
      def successful
        @success = true
      end

      def failure
        @success = false
      end
      #endregion

      #region Private
      private
      def _safe
        return Hash[ DiabeticToolbox.safe(subject_safe_identity).each.map { |n| [n, @options.subject[n]] } ] if can_generate_safe?
        {}
      end

      def can_generate_safe?
        return false if @options.unsafe?
        DiabeticToolbox.safe(subject_safe_identity).length > 0 && @options.subject.present?
      end

      def subject_safe_identity
        @options.subject.class.name.split('::').last.underscore.to_sym
      end

      def error_count
        count = 0
        count = @options.subject.errors.messages.keys.length if @options.subject.present?
        count
      end

      def validation_errors
        return {} unless error_count > 0
        @options.subject.errors.messages
      end
      #endregion
    end
    private_constant :Base
    #endregion

    #region Implementations
    class Success < Base
      def initialize(&block)
        super &block
        successful
      end
    end
    private_constant :Success

    class Failure < Base
      def initialize(&block)
        super &block
        failure
      end
    end
    private_constant :Failure
    #endregion

    #region Spawning Pools
    def self.failure(&block)
      Failure.new &block
    end

    def self.success(&block)
      Success.new &block
    end
    #endregion
  end
end