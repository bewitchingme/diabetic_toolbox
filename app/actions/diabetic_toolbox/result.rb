module DiabeticToolbox
  module Result
    class Base
      def initialize(options)
        @model = options[:model]
        @msg   = options[:message]

        if options.has_key? :safe
          @safe     = options[:safe]
        end

        @messages = if has_validation_errors?
                      validation_errors
                    else
                      {}
                    end
      end

      def success?
        @success
      end

      def flash
        @msg
      end

      def response
        [@msg, @messages, _safe]
      end

      def actual
        @model
      end

      protected
      def successful
        @success = true
      end

      def failure
        @success = false
      end

      private
      def _safe
        Hash[ @safe.each.map { |n| [n, @model[n]] } ] if @safe.length > 0
      end

      def has_validation_errors?
        validation_errors.keys.length > 0
      end

      def validation_errors
        @model.errors.messages
      end
    end

    class Success < Base
      def initialize(options)
        super(options)
        successful
      end
    end

    class Failure < Base
      def initialize(options)
        super(options)
        failure
      end
    end
  end
end