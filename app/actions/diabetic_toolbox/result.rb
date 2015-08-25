module DiabeticToolbox
  module Result
    #region Base
    class Base
      #region New
      def initialize(&block)
        @options = {
          subject: nil,
          message: I18n.t('result.blank')
        }

        if block_given?
          block.call @options
        end

        @messages = if has_validation_errors?
                      validation_errors
                    else
                      {}
                    end
      end
      #endregion

      #region Public
      def success?
        @success
      end

      def flash
        @options[:message]
      end

      def response
        [flash, @messages, _safe]
      end

      def actual
        @options[:subject]
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
        Hash[ DiabeticToolbox.safe(subject_safe_identity).each.map { |n| [n, @options[:subject][n]] } ] if can_generate_safe?
      end

      def can_generate_safe?
        DiabeticToolbox.safe(subject_safe_identity).length > 0 && @options[:subject].present?
      end

      def subject_safe_identity
        @options[:subject].class.name.split('::').last.downcase.to_sym
      end

      def has_validation_errors?
        validation_errors.keys.length > 0 if validation_errors
      end

      def validation_errors
        @options[:subject].errors.messages if @options[:subject]
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